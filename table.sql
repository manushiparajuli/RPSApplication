-- Dropping tables
DROP TABLE IF EXISTS tblRounds; 
DROP TABLE IF EXISTS tblGames; 
DROP TABLE IF EXISTS tblPlayers;
--Creating Table
CREATE TABLE tblPlayers (
  p_id CHAR(8),
  p_doc DATE NOT NULL,
  CONSTRAINT playersPK PRIMARY KEY (p_id)
);
--Creating Table
CREATE TABLE tblGames (
  g_id INTEGER,
  g_doc DATE NOT NULL,
  p1_id CHAR(8) NOT NULL REFERENCES tblPlayers (p_id),
  p2_id CHAR(8) NOT NULL REFERENCES tblPlayers (p_id),
  CONSTRAINT gamesPK PRIMARY KEY (g_id),
  CONSTRAINT check_player CHECK (p2_id > p1_id),
  CONSTRAINT unique_players UNIQUE (p1_id, p2_id)
);

--Creating Table
CREATE TABLE tblRounds (
  r_id INTEGER,
  r_doc DATE NOT NULL,
  g_id INTEGER NOT NULL REFERENCES tblGames(g_id),
  p1_token CHAR(1) NOT NULL,
  p2_token CHAR(1) NOT NULL,
  CONSTRAINT roundsPK PRIMARY KEY (r_id),
  CONSTRAINT token CHECK (p1_token IN ('R', 'P', 'S') AND p2_token IN ('R', 'P', 'S'))
);
-- Insert data into tblPlayers
INSERT INTO tblPlayers (p_id, p_doc) VALUES ('Al', NOW());
INSERT INTO tblPlayers (p_id, p_doc) VALUES ('Bob', NOW());
INSERT INTO tblPlayers (p_id, p_doc) VALUES ('Chas', NOW());
INSERT INTO tblPlayers (p_id, p_doc) VALUES ('Debbie', NOW());


-- Insert data into tblGames
INSERT INTO tblGames (g_id, g_doc, p1_id, p2_id) VALUES (1, NOW(), 'Al', 'Chas');
INSERT INTO tblGames (g_id, g_doc, p1_id, p2_id) VALUES (2, NOW(), 'Chas', 'Debbie');
INSERT INTO tblGames (g_id, g_doc, p1_id, p2_id) VALUES (3, NOW(), 'Al', 'Bob');
INSERT INTO tblGames (g_id, g_doc, p1_id, p2_id) VALUES (4, NOW(), 'Bob', 'Debbie');

-- Insert data into tblRounds
INSERT INTO tblRounds (r_id, r_doc, g_id, p1_token, p2_token) VALUES (1, NOW(), 2, 'R', 'P');
INSERT INTO tblRounds (r_id, r_doc, g_id, p1_token, p2_token) VALUES (2, NOW(), 1, 'P', 'S');
INSERT INTO tblRounds (r_id, r_doc, g_id, p1_token, p2_token) VALUES (3, NOW(), 2, 'S', 'P');
INSERT INTO tblRounds (r_id, r_doc, g_id, p1_token, p2_token) VALUES (4, NOW(), 3, 'P', 'R');
