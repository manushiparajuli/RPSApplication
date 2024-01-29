/*
    Considering this one, I see that the player IDs are only
    used to derive the game ID.  Once we do that, we no longer
    have any need of them.  If anything is wrong with the player
    IDs, the getGameID function will return NULL.  This can be a 
    single error code and our logic ends there.  I see 4 error codes:
    0, 1, 2, and 3.
*/
DROP PROCEDURE IF EXISTS procInsertRound;

CREATE OR REPLACE PROCEDURE procInsertRound (
    IN parmP1_id CHAR(16),
    IN parmP1_token CHAR(1),
    IN parmP2_id CHAR(16),
    IN parmP2_token CHAR(1),
    INOUT parmErr_lvl SMALLINT
)
LANGUAGE plpgsql SECURITY DEFINER
AS $GO$
DECLARE
    lvG_id INTEGER;
BEGIN
    -- grab the Game Id immediately
    SELECT getGameID(parmP1_id, parmP2_id) INTO lvG_id;
    
    -- If it's NULL, we're done. Error code 1 (no game for some reason)
    IF lvG_id IS NULL THEN
        parmErr_lvl := 1;
        RETURN;
    ELSE
        -- IF lvG_id is negative means the parameters are swapped
        IF lvG_id < 0 THEN
            -- swap the tokens (we're done with the p_ids)
            SELECT CASE
                WHEN parmP1_token = 'R' THEN
                    parmP1_token := 'S';
                WHEN parmP1_token = 'P' THEN
                    parmP1_token := 'R';
                WHEN parmP1_token = 'S' THEN
                    parmP1_token := 'P';
            END CASE;
            
            SELECT CASE
                WHEN parmP2_token = 'R' THEN
                    parmP2_token := 'S';
                WHEN parmP2_token = 'P' THEN
                    parmP2_token := 'R';
                WHEN parmP2_token = 'S' THEN
                    parmP2_token := 'P';
            END CASE;
            
            -- Flip the sign of the game ID
            lvG_id := -lvG_id;
        END IF;

        -- Now, a short logical ladder to check the tokens:
        IF parmP1_token IS NULL OR parmP2_token IS NULL THEN
            -- Error code 2
            parmErr_lvl := 2;
        ELSIF parmP1_token NOT IN ('R', 'P', 'S') OR parmP2_token NOT IN ('R', 'P', 'S') THEN
            -- Error code 3
            parmErr_lvl := 3;
        ELSE
            -- Error code 0 (we didn't set it at first)
            -- INSERT
            INSERT INTO tblRounds (r_game_id, r_p1_token, r_p2_token)
            VALUES (lvG_id, parmP1_token, parmP2_token);
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO tblErrata(e_doc, e_sqlState, e_sqlErrm)
        VALUES(NOW(), SQLSTATE, SQLERRM);
        
        RAISE WARNING E'Exception Raised.  See errata log.\n';
        parmErr_lvl := -13;
END $GO$;

-- Test case for procInsertRound
SELECT createGame('p1', 'p2');
DO $$
DECLARE
    err_lvl SMALLINT;
BEGIN
    CALL procInsertRound('p1', 'R', 'p2', 'P', err_lvl);
    ASSERT err_lvl = 0, 'Expected error level 0';
END $$;

DO $$
DECLARE
    err_lvl SMALLINT;
BEGIN
    CALL procInsertRound('p2', 'P', 'p1', 'R', err_lvl);
    ASSERT err_lvl = 0, 'Expected error level 0';
END $$;
DO $$
DECLARE
    err_lvl SMALLINT;
BEGIN
    CALL procInsertRound('p1', NULL, 'p2', 'P', err_lvl);
    ASSERT err_lvl = 2, 'Expected error level 2';
END $$;
DO $$
DECLARE
    err_lvl SMALLINT;
BEGIN
    CALL procInsertRound('p1', 'R', 'p2', 'X', err_lvl);
    ASSERT err_lvl = 3, 'Expected error level 3';
END $$;
