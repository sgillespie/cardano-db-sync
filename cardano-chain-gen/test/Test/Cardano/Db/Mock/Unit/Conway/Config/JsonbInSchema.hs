{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE OverloadedStrings #-}

module Test.Cardano.Db.Mock.Unit.Conway.Config.JsonbInSchema (
  configRemoveJsonbFromSchemaEnabled,
  configRemoveJsonbFromSchemaDisabled,
  configJsonbInSchemaShouldRemoveThenAdd,
) where

import qualified Cardano.Db as DB
import Cardano.DbSync.Config (SyncNodeConfig (..))
import Cardano.DbSync.Config.Types (RemoveJsonbFromSchemaConfig (..), SyncInsertOptions (..))
import Cardano.Mock.ChainSync.Server (IOManager ())
import Cardano.Prelude hiding (head)
import Test.Cardano.Db.Mock.Config
import Test.Cardano.Db.Mock.Validate
import Test.Tasty.HUnit (Assertion ())

configRemoveJsonbFromSchemaEnabled :: IOManager -> [(Text, Text)] -> Assertion
configRemoveJsonbFromSchemaEnabled ioManager metadata = do
  syncNodeConfig <- mksNodeConfig
  withCustomConfigAndDropDB args (Just syncNodeConfig) cfgDir testLabel action ioManager metadata
  where
    action = \_interpreter _mockServer dbSync -> do
      startDBSync dbSync
      threadDelay 7_000_000
      assertEqQuery
        dbSync
        DB.queryJsonbInSchemaExists
        False
        "There should be no jsonb data types in database if option is enabled"
      checkStillRuns dbSync

    args = initCommandLineArgs {claFullMode = False}
    testLabel = "conwayConfigRemoveJsonbFromSchemaEnabled"

    cfgDir = conwayConfigDir

    mksNodeConfig :: IO SyncNodeConfig
    mksNodeConfig = do
      initConfigFile <- mkSyncNodeConfig cfgDir args
      let dncInsertOptions' = dncInsertOptions initConfigFile
      pure $
        initConfigFile
          { dncInsertOptions = dncInsertOptions' {sioRemoveJsonbFromSchema = RemoveJsonbFromSchemaConfig True}
          }

configRemoveJsonbFromSchemaDisabled :: IOManager -> [(Text, Text)] -> Assertion
configRemoveJsonbFromSchemaDisabled ioManager metadata = do
  syncNodeConfig <- mksNodeConfig
  withCustomConfigAndDropDB args (Just syncNodeConfig) cfgDir testLabel action ioManager metadata
  where
    action = \_interpreter _mockServer dbSync -> do
      startDBSync dbSync
      threadDelay 7_000_000
      assertEqQuery
        dbSync
        DB.queryJsonbInSchemaExists
        True
        "There should be jsonb types in database if option is disabled"
      checkStillRuns dbSync

    args = initCommandLineArgs {claFullMode = False}
    testLabel = "conwayConfigRemoveJsonbFromSchemaDisabled"

    cfgDir = conwayConfigDir

    mksNodeConfig :: IO SyncNodeConfig
    mksNodeConfig = do
      initConfigFile <- mkSyncNodeConfig cfgDir args
      let dncInsertOptions' = dncInsertOptions initConfigFile
      pure $
        initConfigFile
          { dncInsertOptions = dncInsertOptions' {sioRemoveJsonbFromSchema = RemoveJsonbFromSchemaConfig False}
          }

configJsonbInSchemaShouldRemoveThenAdd :: IOManager -> [(Text, Text)] -> Assertion
configJsonbInSchemaShouldRemoveThenAdd ioManager metadata = do
  syncNodeConfig <- mksNodeConfig
  withCustomConfigAndDropDB args (Just syncNodeConfig) cfgDir testLabel action ioManager metadata
  where
    action = \_interpreter _mockServer dbSync -> do
      startDBSync dbSync
      threadDelay 7_000_000
      assertEqQuery
        dbSync
        DB.queryJsonbInSchemaExists
        False
        "There should be no jsonb types in database if option has been enabled"
      stopDBSync dbSync
      let newDbSyncEnv =
            dbSync
              { dbSyncConfig =
                  (dbSyncConfig dbSync)
                    { dncInsertOptions =
                        (dncInsertOptions $ dbSyncConfig dbSync)
                          { sioRemoveJsonbFromSchema = RemoveJsonbFromSchemaConfig False
                          }
                    }
              }
      startDBSync newDbSyncEnv
      threadDelay 7_000_000
      assertEqQuery
        dbSync
        DB.queryJsonbInSchemaExists
        True
        "There should be jsonb types in database if option has been disabled"
      -- Expected to fail
      checkStillRuns dbSync

    args = initCommandLineArgs {claFullMode = False}
    testLabel = "configJsonbInSchemaShouldRemoveThenAdd"

    cfgDir = conwayConfigDir

    mksNodeConfig :: IO SyncNodeConfig
    mksNodeConfig = do
      initConfigFile <- mkSyncNodeConfig cfgDir args
      let dncInsertOptions' = dncInsertOptions initConfigFile
      pure $
        initConfigFile
          { dncInsertOptions = dncInsertOptions' {sioRemoveJsonbFromSchema = RemoveJsonbFromSchemaConfig True}
          }
