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


-- Test code
DO
$GO$
DECLARE
    lvErrLvl SMALLINT;
BEGIN
    CALL procInsertPlayer('aaa', lvErrLvl);
    RAISE NOTICE 'Procedure terminated; error level = %', lvErrLvl;
END $GO$;

DO $$
DECLARE
    errlvl SMALLINT;
BEGIN
    CALL procInsertPlayer('player1', errlvl);
    IF errlvl = 0 THEN RAISE NOTICE 'Insert successful!'; END IF;
END$$;

DO $$
DECLARE
    errlvl SMALLINT;
BEGIN
    CALL procInsertPlayer(NULL, errlvl);
    IF errlvl = 1 THEN RAISE NOTICE 'Null input caught!'; END IF;
END$$;

DO $$
DECLARE
    errlvl SMALLINT;
BEGIN
    CALL procInsertPlayer('player1', errlvl);
    IF errlvl = 2 THEN RAISE NOTICE 'Duplicate input caught!'; END IF;
END$$;


--Test Code
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
