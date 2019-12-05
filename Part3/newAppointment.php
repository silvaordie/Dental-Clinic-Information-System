<html>

    <body>

    <h3>New Appointment</h3>
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

    echo("<form action='newAppointment.php' method='post'>");
    echo("<p> Client Vat: <input type='text' name='VAT_client' value='$VAT'></p>");

    ?>
            
            <p>Date:  <input type="date" name="app_date"> </p>
            <p>Time:  <input type="number" name="app_time" min="9" max="16"> </p>
            <p>Description: <input type='text' name='description'> </p>
            <p>Vat Doctor: <input type='text' name='VAT_doctor'> </p>
            <input type ='submit' value= 'New Appoitment'/>
    </form>

    <?
    $VAT_client=$_REQUEST['VAT_client'];
    $app_timestamp = $_REQUEST['app_date'].' '.$_REQUEST['app_time'].':00:00';
    $description = $_REQUEST['description'];
    $VAT_doctor = $_REQUEST['VAT_doctor'];

    if(!empty($VAT_doctor)){
        $result = $connection->prepare("insert into appointment values (?, ?, ?,?)");
        $result->execute(array($VAT_doctor,$app_timestamp,$description,$VAT_client));
        
        $error = $result->errorInfo();
        if ($error[1] != ''){
            echo("<p>Error: {$error[2]}</p>");
        }
        else{
            echo("New appointment inserted");
        }
    }


    ?>


    <form action="newAppointment.php" method="post">
            <h3>List Availabe Doctor</h3>
            <p>Date:  <input type="date" name="app_date_"> </p>
            <p>Time (h):  <input type="number" name="app_time_" min="9" max="16"> </p>
            <input type ='submit' value= 'List doctors'/>
        </form>


        <?php

        $app_timestamp = $_REQUEST['app_date_'].' '.$_REQUEST['app_time_'].':00';

        $time1 = $_REQUEST['app_time_'].':00';
        $time2 = "01:00";
        
        $time2 = date("H:i",strtotime($time1)+strtotime($time2));

        $app_timestamp2 = $_REQUEST['app_date_'].' '.$time2; 
        if(!empty($_REQUEST['app_date_'])&&!empty($_REQUEST['app_time_']))
        {
            echo("<h3>Available Doctors $app_timestamp</h3>");

            $result = $connection->prepare("SELECT doc.name, doc.VAT from employee doc, doctor where doc.VAT = doctor.VAT and doc.VAT not in( select app.VAT_doctor from appointment app where app.VAT_doctor and app.date_timestamp BETWEEN ? AND ?) group by doc.VAT");
            $result->execute(array($app_timestamp, $app_timestamp2));

            
            $nrows = $result->rowCount();
            if ($nrows == 0)
            {
            echo("<p>There is no doctor available.</p>");
            }
            else
            {   
                echo("<table>");
                echo("<tr> <th>Name</th> <th>VAT</th></tr>");
                foreach($result->fetchAll(PDO::FETCH_ASSOC) as $row)
                {
                    echo("<tr>");
                    echo("<td>{$row['name']}</td> <td>{$row['VAT']} </td>");
                    echo("</tr>");

                }
                echo("</table>");
            }
        }
        
        $connection = null;
        ?>
    

    </body>


</html>