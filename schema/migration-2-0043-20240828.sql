-- Persistent generated migration.

CREATE FUNCTION migrate() RETURNS void AS $$
DECLARE
  next_version int ;
BEGIN
  SELECT stage_two + 1 INTO next_version FROM schema_version ;
  IF next_version = 43 THEN
    EXECUTE 'ALTER TABLE "committee_member" DROP CONSTRAINT "committee_member_committee_id_fkey"' ;
    EXECUTE 'ALTER TABLE "committee_member" ADD CONSTRAINT "committee_member_committee_id_fkey" FOREIGN KEY("committee_id") REFERENCES "committee"("id") ON DELETE CASCADE  ON UPDATE RESTRICT' ;
    -- Hand written SQL statements can be added here.
    UPDATE schema_version SET stage_two = next_version ;
    RAISE NOTICE 'DB has been migrated to stage_two version %', next_version ;
  END IF ;
END ;
$$ LANGUAGE plpgsql ;

SELECT migrate() ;

DROP FUNCTION migrate() ;
