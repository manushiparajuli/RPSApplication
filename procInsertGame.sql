/* PSQL/PHP Assignment Part1
 * Manushi Parajuli
 *CSCE 4355
 */
DROP SEQUENCE seqGameId;
CREATE SEQUENCE seqGameId;

DROP PROCEDURE IF EXISTS procInsertGame;
CREATE PROCEDURE procInsertGame (
    IN paramP1 CHAR(16),
    IN paramP2 CHAR(16),
    INOUT parmErrLvl SMALLINT) 
LANGUAGE plpgsql 
SECURITY DEFINER
AS $GO$
BEGIN
    parmErrLvl := 0; --Successful Insert
    IF paramP1 = paramP2 --if p1_id =p2_id
    THEN parmErrLvl := 1;
        
    ELSEIF paramP1 IS NULL OR LENGTH(paramP1) = 0 OR --neither parameter can be null
           paramP2 IS NULL OR LENGTH(paramP2) = 0 
           THEN parmErrLvl := 2;     
    ELSE
        IF EXISTS (SELECT * FROM tblGames --Duplicate pairs
            WHERE (p1_id = paramP1 AND p2_id = paramP2)
            OR (p1_id = paramP2 AND p2_id = paramP1)) 
            THEN parmErrLvl := 3;
      
        ELSE
            IF NOT EXISTS (SELECT * FROM tblPlayers WHERE p_id = paramP1) OR  --if p1_id or p2_id is not in tbl players
               NOT EXISTS (SELECT * FROM tblPlayers WHERE p_id = paramP2) 
               THEN parmErrLvl := 4;     
            ELSE
                INSERT INTO tblGames(game_id, p1_id, p2_id, game_doc)
                VALUES (NEXTVAL('seqGameId'), LEAST(paramP1, paramP2), GREATEST(paramP1, paramP2), NOW());
            END IF;
        END IF;
    END IF; 
    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO tblErrata (e_id, e_doc, e_msg)
            VALUES (NEXTVAL('seqErrata'), CURRENT_DATE, SQLSTATE);        
            parmErrLvl := -13;
END;
$GO$;
GRANT EXECUTE ON PROCEDURE procInsertGame TO public_Users;
DO $GO$
DECLARE
    lvErrLvl SMALLINT;
BEGIN
    CALL procInsertGame('player1', 'player2', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    CALL procInsertGame('', '', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    CALL procInsertGame('Bob', 'Debbie', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    CALL procInsertGame('player1', 'player2', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    --Same players
    CALL procInsertGame('player1', 'player1', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    
    -- Player 1 is null
    CALL procInsertGame(NULL, 'player2', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    
    -- Player 2 is null
    CALL procInsertGame('player1', NULL, lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    
    -- Duplicate pairs
    CALL procInsertGame('player1', 'player2', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    
    -- Player1 ID is not in tblPlayers
    CALL procInsertGame('player1', 'player3', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
    
    -- Player1 ID is not in tblPlayers
    CALL procInsertGame('player4', 'player1', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
END;
$GO$;
--jqpublic and then rps database

psql -h localhost -U jqpublic -d rps--CALL procInsertGame('player1', 'player2', @errCode);

--change the directory to rps

--------------------------------------------------------------------------------------------------------


