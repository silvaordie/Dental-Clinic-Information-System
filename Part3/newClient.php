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
        $phone  =$_REQUEST['phone'];

        $date = new DateTime($birthday);
        $now = new DateTime();
        $interval = $now->diff($date);
        $age = $interval->y;

        if(!empty($VAT)&&!empty($Name)&&!empty($Street)&&!empty($City)&&!empty($Zip)&&!empty($gender)&&!empty($birthday)){
            
            $result = $connection->prepare("insert into client values (?, ?, ?, ?, ?, ?, ? , ?)");
            $result->execute(array($VAT, $Name,$birthday, $Street, $City, $Zip,$gender,$age));

            $error = $result->errorInfo();
            if ($error[1] != ''){
                echo("<p>Error: {$error[2]}</p>");
            }
            else
            {
                echo("<p>New Client assigned</p>");
            }
        }
        

        echo("<form action=newClient.php method='post'>");
        echo("<input type=hidden value=$VAT name =VAT>");
        echo("<p>Phone Number: <input type='text' name='phone'></p>");
        echo("<p><input type='submit' value='Add'></p>");
        echo("</form");
        if(!empty($phone)){
            $result = $connection->prepare("insert into phone_number_client values(?,?)");
            $result->execute(array($phone,$VAT));

            $error = $result->errorInfo();
            if ($error[1] != ''){
                echo("<p>Error: {$error[2]}</p>");
            }
            else
            {
                echo("<p>New phone number inserted </p>");
            }


        }

        $connection = null;

    ?>
    </body>
</html>