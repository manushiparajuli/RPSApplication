CREATE DATABASE rps; -- One time
GRANT CONNECT ON DATABASE rps TO public_Users;
-- ----------------------------------------------



DROP SEQUENCE IF EXISTS seqErrata;
CREATE SEQUENCE seqErrata;

-- -----------------------------------------

DROP TABLE IF EXISTS tblPlayers;
CREATE TABLE tblPlayers
(
    p_id    CHAR(16),  
    p_doc   DATE,
    --
    CONSTRAINT tblPlayers_PK PRIMARY KEY(p_id),
    --
    CONSTRAINT tblPlayers_NULL_pDoc CHECK(p_doc IS NOT NULL)
    --
        -- The next one is not required in part one
        ,CONSTRAINT playersExceptionTest CHECK(p_id <> 'playerError')
        -- The purpose of this constraint is to create a constraint
        -- violation that is not caught
);



-- -------------------------------------------------------------

DROP TABLE IF EXISTS TblErrata;
CREATE TABLE TblErrata
(
    e_id    INTEGER     PRIMARY KEY, -- I know, it's sloppy but it works
    e_doc   DATE,
    e_msg   TEXT
);


-- --------------------------------------------------------------

/*
    Error Codes:
        0 - successful Insert
        1 - NULL paramP_id
        2 - duplicate PK,  paramP_id in table
      -13 - unknown error logged
*/

DROP PROCEDURE IF EXISTS procInsertPlayer;
CREATE PROCEDURE procInsertPlayer (  IN paramP_id CHAR(16),
                                                 INOUT parmErrLvl SMALLINT )
LANGUAGE plpgsql 
SECURITY DEFINER
AS $GO$ 
BEGIN
    parmErrLvl := 0;
    IF paramP_id IS NULL OR LENGTH(paramP_id) = 0
    THEN parmErrLvl := 1;
    ELSIF
        EXISTS ( SELECT * FROM tblPlayers WHERE p_id = paramP_id )
        THEN parmErrLvl := 2;
        ELSE
            INSERT INTO tblPlayers(p_id, p_doc)
            VALUES( paramP_id, NOW() );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO tblErrata(e_id, e_doc, e_msg)
        VALUES( NEXTVAL('seqErrata'), CURRENT_DATE, SQLSTATE );
        
        parmErrLvl:=-13;
        
        -- RAISE WARNING E'Exception Raised.  See errata log.\n';
        --
        -- If it's designed to run on a web server, there won't
        -- *BE* any console to which the output might be written,        
END $GO$;

GRANT EXECUTE ON PROCEDURE procInsertPlayer TO public_Users;
/*
    Caution: if an object (such as a procedure) is recompiled, many 
    databases will revoke all grants.
*/    

-- ----------------------------------------------------

-- Test code
DO
$GO$
DECLARE
    lvErrLvl SMALLINT;
BEGIN
    CALL procInsertPlayer('aaa', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
END $GO$;

/*
    Now, J.Q. logs in
    
    psql -h localhost -U jqpublic --password
    
    J.Q. Can execute the code above
*/