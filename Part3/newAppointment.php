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

    echo("<form action='newAppointment.php' methop='post'>");
    echo("<p> Client Vat: <input type='text' name='VAT_client' value='$VAT'></p>");

    ?>
            
            <p>Date:  <input type="date" name="app_date"> </p>
            <p>Time:  <input type="time" name="app_time"> </p>
            <p>Description: <input type='text' name='description'> </p>
            <p>Vat Doctor: <input type='text' name='VAT_doctor'> </p>
            <input type ='submit' value= 'New Appoitment'/>
    </form>

    <?
    $VAT_client=$_REQUEST['VAT_client'];
    $app_timestamp = $_REQUEST['app_date'].' '.$_REQUEST['app_time'].':00';
    $description = $_REQUEST['description'];
    $VAT_doctor = $_REQUEST['VAT_doctor'];

    if(!empty($VAT_doctor)){
        $sql = "insert into appointment values ('$VAT_client', '$app_timestamp', '$description', '$VAT_doctor')";

        $result = $connection->query($sql);
        echo($result);        
    }


    ?>


    <form action="newAppointment.php" method="post">
            <h3>List Availabe Doctor</h3>
            <p>Date:  <input type="date" name="app_date"> </p>
            <p>Time (h):  <input type="number" name="app_time" min="9" max="16"> </p>
            <input type ='submit' value= 'List doctors'/>
        </form>


        <?php

        $app_timestamp = $_REQUEST['app_date'].' '.$_REQUEST['app_time'].':00';

        $time1 = $_REQUEST['app_time'].':00';
        $time2 = "01:00";
        
        $time2 = date("H:i",strtotime($time1)+strtotime($time2));

        $app_timestamp2 = $_REQUEST['app_date'].' '.$time2; 
        if(!empty($_REQUEST['app_date'])&&!empty($_REQUEST['app_time']))
        {
            echo("<h3>Available Doctors $app_timestamp</h3>");
            $sql = "SELECT doc.name, doc.VAT from employee doc, doctor where doc.VAT = doctor.VAT and doc.VAT not in( select app.VAT_doctor from appointment app where app.VAT_doctor and app.date_timestamp BETWEEN '$app_timestamp' AND '$app_timestamp2') group by doc.VAT";
            $result = $connection->query($sql);
            $nrows = $result->rowCount();
            if ($nrows == 0)
            {
            echo("<p>There is no doctor available.</p>");
            }
            else
            {   
                echo("<table>");
                echo("<tr> <th>Name</th> <th>VAT</th></tr>");
                foreach($result as $row)
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