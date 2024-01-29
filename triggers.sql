/*

    These aren't assigned yet.  You might get here, and, if you do, that's great!
    Get everything else running first, though!
    
    This set of triggers block any actions on the tables besides INSERT.
    
    This example blocks DELETE on tblPlayers.  To block UPDATE, change it to:
    
    CREATE TRIGGER trigBlockUpdate BEFORE UPDATE ON tblPlayers ... use the same function.


*/

CREATE OR REPLACE FUNCTION funcBlockDML() RETURNS TRIGGER
-- Blocks specific Data Manipulation Language (DML) statement on table
LANGUAGE plpgsql
SECURITY DEFINER
AS $GO$
BEGIN
        RAISE EXCEPTION '% operation blocked on %.', TG_OP, TG_TABLE_NAME
                USING ERRCODE = '0W000'; 
        -- Code for: "prohibited statement encountered during trigger execution"    
        -- Control now transfers to Exception handler and an event is logged
END;
$GO$;




DROP TRIGGER IF EXISTS trigBlockDelete ON tblPlayers; 

CREATE TRIGGER trigBlockDelete BEFORE DELETE ON tblPlayers
    FOR EACH STATEMENT
    EXECUTE FUNCTION funcBlockDML();
