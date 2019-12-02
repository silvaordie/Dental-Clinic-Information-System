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
        $num_phones  =$_REQUEST['num_phones'];

        $date = new DateTime($birthday);
        $now = new DateTime();
        $interval = $now->diff($date);
        $age = $interval->y;

        $sql = "insert into client values ('$VAT', '$Name', '$birthday', '$Street', '$City', '$Zip', '$gender' , '$age')";

        $result = $connection->exec($sql);
        echo("<p>$sql</p>");
        echo("<p>New Client assigned: $result </p>");

        echo("<form action=phones.php method='post'>");
        echo("<input type=hidden value=$VAT name =VAT>");
        echo("<input type=hidden value=$$num_phones name =num_phones>");

        for($i=1;$i<=$num_phones;$i++)
        {
            echo("<p>Phone Number: <input type='text' name='phone[$i]'></p>");
        }
        echo("</form");

        $connection = null;

    ?>
    </body>
</html>