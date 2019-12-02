<html>
    <body>
    <?php

        $host = "db.tecnico.ulisboa.pt";
        $user = "ist425466";
        $pass = "ojrc6899";
        $dsn = "mysql:host=$host;dbname=$user";
        try
        {
        $connection = new PDO($dsn, $user, $pass);
        }
        catch(PDOException $exception)
        {
        echo("<p>Error: ");
        echo($exception->getMessage());
        echo("</p>");
        exit();
        }

        $VAT = $_REQUEST['VAT'];
        $phone = $_REQUEST['phone'];
        $num_phones  =$_REQUEST['num_phones'];


        $connection->beginTransaction();
    
        for($i=1;$i<=num_phones;$i++){
            if(!empty($measure[$i][$j])){
                $sql = "insert into phone_number_client values ('$VAT', '$phone[$i]')";
                $result = $connection->exec($sql); 
            }
        } 
    
        $connection->commit();




        $connection = null;

    ?>
    </body>
</html>