
<!DOCTYPE html>
<html>
    <head>
        <style>
            button {
                background-color: #4CAF50; /* Green */
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
            }
            
            button[type="submit"] {
                background-color: #008CBA; /* Blue */
            }
            
            button[type="reset"] {
                background-color: #f44336; /* Red */
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
        <?php
             //Database connection
            include("include/connect.php");
            if(! $dbConn)
            {
                die('Failed to connect');
            }
            // Player 1 and player 2
            $player_1 = $_POST['player_1'];
            $player_2 = $_POST['player_2'];
            //Checking if player 1 and player 2 are null or not
            if ($player_1 && $player_2 && $player_1 != $player_2) {
                //ProcInsertGame procedure to pass the parameters
                $com_string = "CALL procInsertGame($1, $2, $3)";
                $result = pg_query_params($dbConn, $com_string, array($player_1, $player_2, &$parmErrLvl));
                 //checking the query  
                if (!$result) {
                    $outPut = "Error: " . pg_last_error($dbConn);
                } else {
                    // Parsing and displaying the text area
                    $output = pg_fetch_result($result, 0);
                    $outPut = "Output: " . $output;
                }
            } else {
                // Error message incase player 1 and player 2 empty
                if (!$player_1 || !$player_2) {
                    $outPut = "Error: Enter the names of both players";
                } else {
                    $outPut = "Error: Duplicate player name not allowed";
                }
            }
        ?>
        <!-- Display the output & go back to start -->
        <form action="/index.html">
            <div>
                <textarea class="message" name="feedback" text-align: center;
                        id="feedback" rows=1 cols=80 readonly="enabled">
                    <?php echo $outPut; ?>
                </textarea>
            </div>
            <button type="submit">Return</button>
            <button type="reset">Clear</button>
            <button type="button" class="return-button" onclick="window.history.back()">Return</button>

        </form> 
	</body>
    
</html>
