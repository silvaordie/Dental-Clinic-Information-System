<html>

    <body>

    <h3>List of Appointments/Consultations for Client <?php echo("{$_REQUEST['VAT']}") ?></h3>
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
	
	$sql = "SELECT * FROM appointment NATURAL LEFT OUTER JOIN consultation where VAT_client = '$VAT' order by date_timestamp";
	$result = $connection->query($sql);
	$nrows = $result->rowCount();
	if ($nrows == 0)
	{
		echo("<p>There are no records for this client.</p>");
	}
	else
	{   
		echo("<table>");
		echo("<tr> <th>TYPE</th> <th>DATE</th> <th>DOCTOR</th> </tr>");
		foreach($result as $row)
		{
			$date = $row['date_timestamp'];
			$doctor = $row['VAT_doctor'];
			echo("<tr>");
			echo("<td>Appointment</td> <td>{$date}</td> <td>{$doctor}</td>");
			echo("<form action='appointment.php' method='post'>");
			echo("<input type='hidden' name='date' value='{$date}'>");
			echo("<input type='hidden' name='doctor' value='{$doctor}'>");
			echo("<input type='hidden' name='description' value='{$row['description']}'>");
			echo("<input type='hidden' name='client' value='{$VAT}'>");
			echo("<td><input type='submit' value='Show Details'/></td>");
			echo("</form>");
			echo("</tr>");
			if (!empty($row['SOAP_S']) or !empty($row['SOAP_O']) or !empty($row['SOAP_A']) or !empty($row['SOAP_P']))
			{
				echo("<tr>");
				echo("<td>Consultation</td> <td>{$row['date_timestamp']}</td> <td>{$row['VAT_doctor']}</td>");
				echo("<form action='consultation.php' method='post'>");
				echo("<input type='hidden' name='date' value='{$date}'>");
				echo("<input type='hidden' name='doctor' value='{$doctor}'>");
				echo("<input type='hidden' name='soap_s' value='{$row['SOAP_S']}'>");
				echo("<input type='hidden' name='soap_o' value='{$row['SOAP_O']}'>");
				echo("<input type='hidden' name='soap_a' value='{$row['SOAP_A']}'>");
				echo("<input type='hidden' name='soap_a' value='{$row['SOAP_P']}'>");
				echo("<td><input type='submit' value='Show Details'/></td>");
				echo("</form>");
				echo("</tr>");
			}
		}
		echo("</table>");
	}
	?>
	
	</body>

</html>