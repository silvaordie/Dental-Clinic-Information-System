<html>

<body>
<form action="doctorsearch.php" method="post">
<h3>Search Client</h3>
<p>VAT: <input type="text" name="VAT"/></p>
<p>Name: <input type="text" name="Name"/></p>
<p>Address: Street: <input type="text" name="Street"/> City: <input type="text" name="City"/> Zip: <input type="text" name="Zip"/></p>

<p><input type="submit"/></p>
</form>

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
        if(!empty($VAT)||!empty($Name)||!empty($Street)||!empty($City)||!empty($Zip))
        {
            $sql = "SELECT VAT, name FROM client WHERE client.VAT LIKE '%$VAT%' and client.name LIKE '%$Name%' and client.street LIKE '%$Street%' and client.city LIKE '%$City%' and client.zip LIKE '%$Zip%'";
            $result = $connection->query($sql);
            $nrows = $result->rowCount();
            if ($nrows == 0)
            {
            echo("<p>There is no client with such info.</p>");
            }
            else
            {   
                echo("<table>");
                echo("<tr> <th>Name</th> <th>VAT</th> <th></th> </tr>");
                foreach($result as $row)
                {
                    echo("<tr><form action='newAppointment.php' method='post'>");
                    echo("<td>{$row['name']}</td> <td><input type='hidden' name='VAT' value='{$row['VAT']}'>{$row['VAT']} </td>");
                    echo("<td>  <input type='submit' value='Add Appointment'/>  </td>");
                    echo("</form>");
					echo("<form action='listAppointments.php' method='post'>");
                    echo("<td><input type='hidden' name='VAT' value='{$row['VAT']}'></td>");
                    echo("<td><input type='submit' value='List Appointements/Consultations'/></td>");
                    echo("</form> </tr>");

                }
                echo("</table>");
            }
        }
        ?>

        <form action="newClient.php" method="post"> 
            <h3> New Client </h3>
            <p>VAT: <input type="text" name="VAT"/></p>
            <p>Name: <input type="text" name="Name"/></p>
            <p>Birth date: <input type="date" name="birth_date"></p>
            <p>Gender: <input type="radio" name="gender" value="M" > Male  
                    <input type="radio" name="gender" value="F"> Female  
                    <input type="radio" name="gender" value="O"> Other</p>
            <p>Address: Street: <input type="text" name="Street"/> City: <input type="text" name="City"/> Zip: <input type="text" name="Zip"/></p>
            
            
            <input type="submit" value ='Add Client'/>



        </form>


        <form action="doctorsearch.php" method="post">
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
