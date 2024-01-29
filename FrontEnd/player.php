<html>
    <head>
        <meta charset="UTF-8">
        <title>Insert Player</title>
        <style>
            body {
                font-family: sans-serif;
                background-color: #f7f7f7;
            }
            
            form {
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            label {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 5px;
            }

            input[type="text"] {
                width: 100%;
                padding: 10px;
                border-radius: 5px;
                border: 1px solid #ccc;
                margin-bottom: 15px;
            }

            button[type="submit"] {
                background-color: #7d4cdb;
                color: white;
                padding: 10px 20px;
                border-radius: 25px;
                border: none;
                cursor: pointer;
                margin-top: 20px;
                font-size: 1.1rem;
                transition: background-color 0.3s ease;
            }

            button[type="submit"]:hover {
                background-color: #5e37c5;
            }

            .message {
                font-size: 1.2rem;
                font-weight: bold;
                padding: 10px;
                border-radius: 5px;
                border: 1px solid #ccc;
                margin-bottom: 15px;
                text-align: center;
            }

            .return-button {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                border-radius: 25px;
                border: none;
                cursor: pointer;
                font-size: 1.1rem;
                transition: background-color 0.3s ease;
            }

            .return-button:hover {
                background-color: #3e8e41;
            }
        </style>
    </head>
    <body>
        <?php
            require 'include/connect.php';

            if (! $dbConn )
            {
                die('Connection failed');
            }

            $player = $_POST['player'];
            $com_string = 'CALL procInsertPlayer($1, NULL)';
            $result = pg_query_params($dbConn, $com_string, array($player));

            if( ! $result )
            {
                die('Unable to CALL stored procedure: ' . pg_last_error());
            }

            $row = pg_fetch_row($result);
            $errLvl = $row[0];

            if ($errLvl == '0')
            {
                $outPut = 'The player ' . $player . ' was successfully inserted.';
            }
            elseif ($errLvl == '1')
            {
                $outPut = 'The parameter was NULL.';
            }
            else
            {
                $outPut = $player . ' is already in use.';
            }

            pg_close($dbConn);
        ?>

        <form>
            <div>
                <textarea class="message" name="feedback" id="feedback" rows=1 cols=80 readonly="enabled">
                    <?php echo $outPut; ?>
                </textarea>
            </div>
            <button type="button" class="return-button" onclick="window.history.back()">Return</button>
        </form>
    </body>
</html>
