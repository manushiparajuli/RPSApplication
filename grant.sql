-- In most platforms, if you recompile the procedure, the 
-- GRANT is revoked automatically and will have to be renewed.

GRANT CONNECT ON DATABASE rps TO public_users;
GRANT EXECUTE ON PROCEDURE procInsertPlayer TO public_users;
GRANT EXECUTE ON PROCEDURE procInsertGame TO public_users;
GRANT EXECUTE ON PROCEDURE procInsertRound TO public_users;