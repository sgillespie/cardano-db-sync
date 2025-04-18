{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Cardano.DbSync.Era.Byron.Genesis (
  insertValidateGenesisDist,
) where

import Cardano.BM.Trace (Trace, logInfo)
import Cardano.Binary (serialize')
import qualified Cardano.Chain.Common as Byron
import qualified Cardano.Chain.Genesis as Byron
import qualified Cardano.Chain.UTxO as Byron
import qualified Cardano.Crypto as Crypto
import qualified Cardano.Db as DB
import qualified Cardano.Db.Schema.Core.TxOut as C
import qualified Cardano.Db.Schema.Variant.TxOut as V
import Cardano.DbSync.Api
import Cardano.DbSync.Api.Types (SyncEnv (..))
import Cardano.DbSync.Cache (insertAddressUsingCache)
import Cardano.DbSync.Cache.Types (CacheAction (..))
import Cardano.DbSync.Config.Types
import qualified Cardano.DbSync.Era.Byron.Util as Byron
import Cardano.DbSync.Era.Util (liftLookupFail)
import Cardano.DbSync.Error
import Cardano.DbSync.Util
import Cardano.Prelude
import Control.Monad.Trans.Control (MonadBaseControl)
import Control.Monad.Trans.Except.Extra (newExceptT)
import qualified Data.ByteString.Char8 as BS
import qualified Data.Map.Strict as Map
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import Database.Persist.Sql (SqlBackend)
import Paths_cardano_db_sync (version)

-- | Idempotent insert the initial Genesis distribution transactions into the DB.
-- If these transactions are already in the DB, they are validated.
insertValidateGenesisDist ::
  SyncEnv ->
  NetworkName ->
  Byron.Config ->
  ExceptT SyncNodeError IO ()
insertValidateGenesisDist syncEnv (NetworkName networkName) cfg = do
  -- Setting this to True will log all 'Persistent' operations which is great
  -- for debugging, but otherwise *way* too chatty.
  if False
    then newExceptT $ DB.runDbIohkLogging (envBackend syncEnv) tracer insertAction
    else newExceptT $ DB.runDbIohkNoLogging (envBackend syncEnv) insertAction
  where
    tracer = getTrace syncEnv

    insertAction :: (MonadBaseControl IO m, MonadIO m) => ReaderT SqlBackend m (Either SyncNodeError ())
    insertAction = do
      disInOut <- liftIO $ getDisableInOutState syncEnv
      let prunes = getPrunes syncEnv

      ebid <- DB.queryBlockId (configGenesisHash cfg)
      case ebid of
        Right bid -> validateGenesisDistribution syncEnv prunes disInOut tracer networkName cfg bid
        Left _ ->
          runExceptT $ do
            liftIO $ logInfo tracer "Inserting Byron Genesis distribution"
            count <- lift DB.queryBlockCount
            when (not disInOut && count > 0) $
              dbSyncNodeError "insertValidateGenesisDist: Genesis data mismatch."
            void . lift $
              DB.insertMeta $
                DB.Meta
                  { DB.metaStartTime = Byron.configStartTime cfg
                  , DB.metaNetworkName = networkName
                  , DB.metaVersion = textShow version
                  }

            -- Insert an 'artificial' Genesis block (with a genesis specific slot leader). We
            -- need this block to attach the genesis distribution transactions to.
            -- It would be nice to not need this artificial block, but that would
            -- require plumbing the Genesis.Config into 'insertByronBlockOrEBB'
            -- which would be a pain in the neck.
            slid <-
              lift . DB.insertSlotLeader $
                DB.SlotLeader
                  { DB.slotLeaderHash = BS.take 28 $ configGenesisHash cfg
                  , DB.slotLeaderPoolHashId = Nothing
                  , DB.slotLeaderDescription = "Genesis slot leader"
                  }
            bid <-
              lift . DB.insertBlock $
                DB.Block
                  { DB.blockHash = configGenesisHash cfg
                  , DB.blockEpochNo = Nothing
                  , DB.blockSlotNo = Nothing
                  , DB.blockEpochSlotNo = Nothing
                  , DB.blockBlockNo = Nothing
                  , DB.blockPreviousId = Nothing
                  , DB.blockSlotLeaderId = slid
                  , DB.blockSize = 0
                  , DB.blockTime = Byron.configStartTime cfg
                  , DB.blockTxCount = fromIntegral (length $ genesisTxos cfg)
                  , -- Genesis block does not have a protocol version, so set this to '0'.
                    DB.blockProtoMajor = 0
                  , DB.blockProtoMinor = 0
                  , -- Shelley specific
                    DB.blockVrfKey = Nothing
                  , DB.blockOpCert = Nothing
                  , DB.blockOpCertCounter = Nothing
                  }
            mapM_ (insertTxOutsByron syncEnv disInOut bid) $ genesisTxos cfg
            liftIO . logInfo tracer $
              "Initial genesis distribution populated. Hash "
                <> renderByteArray (configGenesisHash cfg)

            supply <- lift $ DB.queryTotalSupply $ getTxOutTableType syncEnv
            liftIO $ logInfo tracer ("Total genesis supply of Ada: " <> DB.renderAda supply)

-- | Validate that the initial Genesis distribution in the DB matches the Genesis data.
validateGenesisDistribution ::
  (MonadBaseControl IO m, MonadIO m) =>
  SyncEnv ->
  Bool ->
  Bool ->
  Trace IO Text ->
  Text ->
  Byron.Config ->
  DB.BlockId ->
  ReaderT SqlBackend m (Either SyncNodeError ())
validateGenesisDistribution syncEnv prunes disInOut tracer networkName cfg bid =
  runExceptT $ do
    meta <- liftLookupFail "validateGenesisDistribution" DB.queryMeta

    when (DB.metaStartTime meta /= Byron.configStartTime cfg) $
      dbSyncNodeError $
        Text.concat
          [ "Mismatch chain start time. Config value "
          , textShow (Byron.configStartTime cfg)
          , " does not match DB value of "
          , textShow (DB.metaStartTime meta)
          ]

    when (DB.metaNetworkName meta /= networkName) $
      dbSyncNodeError $
        Text.concat
          [ "validateGenesisDistribution: Provided network name "
          , networkName
          , " does not match DB value "
          , DB.metaNetworkName meta
          ]

    txCount <- lift $ DB.queryBlockTxCount bid
    let expectedTxCount = fromIntegral $ length (genesisTxos cfg)
    when (txCount /= expectedTxCount) $
      dbSyncNodeError $
        Text.concat
          [ "validateGenesisDistribution: Expected initial block to have "
          , textShow expectedTxCount
          , " but got "
          , textShow txCount
          ]
    unless disInOut $ do
      totalSupply <- lift $ DB.queryGenesisSupply $ getTxOutTableType syncEnv
      case DB.word64ToAda <$> configGenesisSupply cfg of
        Left err -> dbSyncNodeError $ "validateGenesisDistribution: " <> textShow err
        Right expectedSupply ->
          when (expectedSupply /= totalSupply && not prunes) $
            dbSyncNodeError $
              Text.concat
                [ "validateGenesisDistribution: Expected total supply to be "
                , DB.renderAda expectedSupply
                , " but got "
                , DB.renderAda totalSupply
                ]
      liftIO $ do
        logInfo tracer "Initial genesis distribution present and correct"
        logInfo tracer ("Total genesis supply of Ada: " <> DB.renderAda totalSupply)

-------------------------------------------------------------------------------

insertTxOutsByron ::
  (MonadBaseControl IO m, MonadIO m) =>
  SyncEnv ->
  Bool ->
  DB.BlockId ->
  (Byron.Address, Byron.Lovelace) ->
  ExceptT SyncNodeError (ReaderT SqlBackend m) ()
insertTxOutsByron syncEnv disInOut blkId (address, value) = do
  case txHashOfAddress address of
    Left err -> throwError err
    Right val -> lift $ do
      -- Each address/value pair of the initial coin distribution comes from an artifical transaction
      -- with a hash generated by hashing the address.
      txId <- do
        DB.insertTx $
          DB.Tx
            { DB.txHash = Byron.unTxHash val
            , DB.txBlockId = blkId
            , DB.txBlockIndex = 0
            , DB.txOutSum = DB.DbLovelace (Byron.unsafeGetLovelace value)
            , DB.txFee = DB.DbLovelace 0
            , DB.txDeposit = Just 0
            , DB.txSize = 0 -- Genesis distribution address to not have a size.
            , DB.txInvalidHereafter = Nothing
            , DB.txInvalidBefore = Nothing
            , DB.txValidContract = True
            , DB.txScriptSize = 0
            , DB.txTreasuryDonation = DB.DbLovelace 0
            }
      --
      unless disInOut $
        case getTxOutTableType syncEnv of
          DB.TxOutCore ->
            void . DB.insertTxOut $
              DB.CTxOutW
                C.TxOut
                  { C.txOutTxId = txId
                  , C.txOutIndex = 0
                  , C.txOutAddress = Text.decodeUtf8 $ Byron.addrToBase58 address
                  , C.txOutAddressHasScript = False
                  , C.txOutPaymentCred = Nothing
                  , C.txOutStakeAddressId = Nothing
                  , C.txOutValue = DB.DbLovelace (Byron.unsafeGetLovelace value)
                  , C.txOutDataHash = Nothing
                  , C.txOutInlineDatumId = Nothing
                  , C.txOutReferenceScriptId = Nothing
                  , C.txOutConsumedByTxId = Nothing
                  }
          DB.TxOutVariantAddress -> do
            let addrRaw = serialize' address
                vAddress = mkVAddress addrRaw
            addrDetailId <- insertAddressUsingCache cache UpdateCache addrRaw vAddress
            void . DB.insertTxOut $
              DB.VTxOutW (mkVTxOut txId addrDetailId) Nothing
  where
    cache = envCache syncEnv

    mkVTxOut :: DB.TxId -> V.AddressId -> V.TxOut
    mkVTxOut txId addrDetailId =
      V.TxOut
        { V.txOutTxId = txId
        , V.txOutIndex = 0
        , V.txOutValue = DB.DbLovelace (Byron.unsafeGetLovelace value)
        , V.txOutDataHash = Nothing
        , V.txOutInlineDatumId = Nothing
        , V.txOutReferenceScriptId = Nothing
        , V.txOutAddressId = addrDetailId
        , V.txOutConsumedByTxId = Nothing
        , V.txOutStakeAddressId = Nothing
        }

    mkVAddress :: ByteString -> V.Address
    mkVAddress addrRaw = do
      V.Address
        { V.addressAddress = Text.decodeUtf8 $ Byron.addrToBase58 address
        , V.addressRaw = addrRaw
        , V.addressHasScript = False
        , V.addressPaymentCred = Nothing -- Byron does not have a payment credential.
        , V.addressStakeAddressId = Nothing -- Byron does not have a stake address.
        }

---------------------------------------------------------------------------------

configGenesisHash :: Byron.Config -> ByteString
configGenesisHash =
  Byron.unAbstractHash . Byron.unGenesisHash . Byron.configGenesisHash

configGenesisSupply :: Byron.Config -> Either Byron.LovelaceError Word64
configGenesisSupply =
  fmap Byron.unsafeGetLovelace . Byron.sumLovelace . map snd . genesisTxos

genesisTxos :: Byron.Config -> [(Byron.Address, Byron.Lovelace)]
genesisTxos config =
  avvmBalances <> nonAvvmBalances
  where
    avvmBalances :: [(Byron.Address, Byron.Lovelace)]
    avvmBalances =
      first (Byron.makeRedeemAddress networkMagic . Crypto.fromCompactRedeemVerificationKey)
        <$> Map.toList (Byron.unGenesisAvvmBalances $ Byron.configAvvmDistr config)

    networkMagic :: Byron.NetworkMagic
    networkMagic = Byron.makeNetworkMagic (Byron.configProtocolMagic config)

    nonAvvmBalances :: [(Byron.Address, Byron.Lovelace)]
    nonAvvmBalances =
      Map.toList $ Byron.unGenesisNonAvvmBalances (Byron.configNonAvvmBalances config)

txHashOfAddress :: Byron.Address -> Either SyncNodeError (Crypto.Hash Byron.Tx)
txHashOfAddress ba = do
  case hashFromBS of
    Just res -> Right res
    Nothing -> Left $ SNErrInsertGenesis "Cardano.DbSync.Era.Byron.Genesis.txHashOfAddress"
  where
    hashFromBS =
      Crypto.abstractHashFromBytes
        . Crypto.abstractHashToBytes
        $ Crypto.serializeCborHash ba
