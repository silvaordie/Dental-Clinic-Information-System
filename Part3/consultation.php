<html>
    <body>

    <h3>Consultation Details</h3>
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

    $doctor = $_REQUEST['doctor'];
    $date = $_REQUEST['date'];



    echo("<p>VAT doctor: $doctor");
    echo("<p>date : {$_REQUEST['date']}");
    echo("<p>SOAP_S: {$_REQUEST['soap_s']}");
    echo("<p>SOAP_O: {$_REQUEST['soap_o']}");
    echo("<p>SOAP_A: {$_REQUEST['soap_a']}");
    echo("<p>SOAP_P: {$_REQUEST['soap_p']}");

    
    $result = $connection->prepare("select * from consultation_diagnostic where VAT_doctor = ? and date_timestamp = ? ");
    $result->execute(array($doctor, $date));

    
    $nrows = $result->rowCount();
    if ($nrows == 0)
    {
    echo("<p>There is no Diagnosis.</p>");
    }
    else 
    {
        foreach($result->fetchAll(PDO::FETCH_ASSOC) as $row)
        {
            echo("<table>");
            echo("<tr><td>Diagnosis ID : {$row['ID']}</td></tr>");


            $result2 = $connection->prepare("select * from prescription as p where p.VAT_doctor=? and p.date_timestamp = ? group by p.name");
            $result2->execute(array($doctor, $date));
            $nrows2 = $result->rowCount();
            if($nrows2 == 0)
            {
                echo("<tr><td></td>");
                echo("<td>No prescription</td>");
                echo("</tr>");

            }
            else
            {
                foreach($result2->fetchAll(PDO::FETCH_ASSOC) as $presc)
                {
                    echo("<tr><td></td>");
                    echo("<td>name, lab: {$presc['name']}, {$presc['lab']} </td>");
                    echo("</tr>");
                    echo("<tr><td></td>");
                    echo("<td> dosage: {$presc['dosage']}</td>");
                    echo("</tr>");
                    echo("<tr><td></td>");
                    echo("<td> description: {$presc['description']}</td>");
                    echo("</tr>");
                }
            } 

            echo("</table>");
        }
    }
 
    echo("<form action='dental_charting.php' method='post'>");
    echo("<input type='hidden' name = 'doctor' value = '$doctor'>");
    echo("<input type='hidden' name = 'date' value = '$date'>");


    $connection = null;

    ?>
    

    <p>
        <input type='hidden' name = 'name' value = 'd4 charting'>
        <input type='submit' value='new dental chart'>
    </form>

   


    </body>
</html>