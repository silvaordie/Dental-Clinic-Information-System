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
        $Name = $_REQUEST['Name'];
        $Street = $_REQUEST['Street'];
        $City = $_REQUEST['City'];
        $Zip = $_REQUEST['Zip'];
        $gender  = $_REQUEST['gender'];
        $birthday = $_REQUEST['birth_date'];

        $date = new DateTime($birthday);
        $now = new DateTime();
        $interval = $now->diff($date);
        $age = $interval->y;

        $sql = "insert into client values ('$VAT', '$Name', '$birthday', '$Street', '$City', '$Zip', '$gender' , '$age')";

        $result = $connection->query($sql);

        header("Location: doctorsearch.php");
    ?>
    </body>
</html>