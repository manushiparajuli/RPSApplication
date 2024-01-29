<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert Round</title>
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
            padding-top: 50px;
        }

        .button {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 8px;
        }

        .button:hover {
            background-color: #3e8e41;
        }

        textarea {
            text-align: center;
        }
        .return-button {
            display: block;
            margin: 0 auto;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease-in-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Insert Round</h1>
        <?php
            require 'include/connect.php';

            if (!$dbConn) {
                die('Connection failed');
            }

            $player1 = $_POST['player1'];
            $player2 = $_POST['player2'];
            $p1_token = $_POST['p1_token'];
            $p2_token = $_POST['p2_token'];

            if ($player1 == $player2) {
                $outPut = "Player IDs must be different.";
            } elseif (empty($player1) || empty($player2) || empty($p1_token) || empty($p2_token)) {
                $outPut = "All fields must be filled in.";
            } else {
                $com_string = 'CALL procInsertRound($1, $2, $3, $4, NULL)';
                $result = pg_query_params($dbConn, $com_string, array($player1, $p1_token, $player2, $p2_token));

                if (!$result) {
                    die('Unable to CALL stored procedure: ' . pg_last_error());
                }

                $row = pg_fetch_row($result);
                $errLvl = $row[0];

                switch ($errLvl) {
                    case '0':
                        $outPut = "The round was successfully inserted.";
                        break;
                    case '1':
                        $outPut = "One or more parameters were NULL.";
                        break;
                    case '2':
                        $outPut = "Invalid player IDs.";
                        break;
                    case '3':
                        $outPut = "Invalid tokens.";
                        break;
                }
            }
            pg_close($dbConn);
        ?>

        <form action="/index.html">
            <div>
                <textarea class="message" name="feedback" id="feedback" rows="1" cols="80" readonly><?php echo $outPut; ?></textarea>
            </div>
            <button type="button" class="return-button" onclick="window.history.back()">Return</button>

        </form>
    </div>
</body>
</html>
