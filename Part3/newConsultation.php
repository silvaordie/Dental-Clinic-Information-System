<html>

    <body>

    <h3>Update Consultation Information</h3>
    <?php
	
    $host = "db.tecnico.ulisboa.pt";
    $user = "ist181282";
    $pass = "opoa7891";
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
	
    $date = $_REQUEST['date'];
    $doctor = $_REQUEST['doctor'];
	
	$sql = "SELECT * FROM consultation WHERE VAT_doctor = '$doctor' and date_timestamp = '$date'";
	$result = $connection->query($sql);
	$nrows = $result->rowCount();
	
	// Get nurses already assigned to this consultation
	$sql2 = "SELECT employee.name AS name, employee.VAT AS VAT FROM consultation_assistant AS ca, employee WHERE ca.VAT_doctor = '$doctor' and ca.date_timestamp = '$date' and ca.VAT_nurse = employee.VAT";
	$result2 = $connection->query($sql2);
	if ($result2 == FALSE)
	{
		$info = $connection->errorInfo();
		echo("<p>Error: {$info[2]}</p>");
		exit();
	}
	$nrows2 = $result2->rowCount();
	
	// Get nurses available for the desired timestamp
	$sql3 = "SELECT employee.name AS name, employee.VAT AS VAT FROM nurse, employee WHERE nurse.VAT NOT IN (SELECT VAT_nurse FROM consultation_assistant WHERE date_timestamp = '$date') AND nurse.VAT = employee.VAT";
	$result3 = $connection->query($sql3);
	$nrows3 = $result3->rowCount();
	
	echo("<table>");
	echo("<tr><td>VAT_DOCTOR:</td> <td>{$doctor}</td></tr>");
	echo("<tr><td>DATE_TIMESTAMP:</td> <td>{$date}</td></tr>");
	
	// if the consultation were not yet created
	if ($nrows == 0)
	{
		echo("<form action='addConsultation.php' method='post'>");
			echo("<input type='hidden' name='doctor' value='{$doctor}'>");
			echo("<input type='hidden' name='date' value='{$date}'>");
			echo("<tr><td>SOAP_S:</td> <td><input type='text' name='SOAP_S'/></td></tr>");
			echo("<tr><td>SOAP_O:</td> <td><input type='text' name='SOAP_O'/></td></tr>");
			echo("<tr><td>SOAP_A:</td> <td><input type='text' name='SOAP_A'/></td></tr>");
			echo("<tr><td>SOAP_P:</td> <td><input type='text' name='SOAP_P'/></td></tr>");
			// if there are nurses available
			if ($nrows3 != 0)
			{
				foreach($result3 as $row3)
				{
					echo("<tr><td>Assistant Nurses: </td> <td><input type='checkbox' name='nurse_list[]' value='{$row3['VAT']}'><label>{$row3['name']} {$row3['VAT']}</label></td></tr>");
				}
			}
			else
			{
				echo("<tr><td>ATTENTION: </td><td>No nurse/assistant available for this consultation</td></tr>");
			}
			echo("<tr><td><input type='submit' value ='Submit Information'/></td></tr>");
		echo("</form></table>");
	}
	else
	{
		foreach($result as $row)
		{
			echo("<form action='updateConsultation.php' method='post'>");
				echo("<input type='hidden' name='doctor' value='{$doctor}'>");
				echo("<input type='hidden' name='date' value='{$date}'>");
				echo("<tr><td>SOAP_S:</td> <td><input type='text' value='{$row['SOAP_S']}' name='SOAP_S'/></td></tr>");
				echo("<tr><td>SOAP_O:</td> <td><input type='text' value='{$row['SOAP_O']}' name='SOAP_O'/></td></tr>");
				echo("<tr><td>SOAP_A:</td> <td><input type='text' value='{$row['SOAP_A']}' name='SOAP_A'/></td></tr>");
				echo("<tr><td>SOAP_P:</td> <td><input type='text' value='{$row['SOAP_P']}' name='SOAP_P'/></td></tr>");
				//Nurses already assigned to this consultation
				if ($nrows2 != 0)
				{
					foreach($result2 as $row2)
					{
						echo("<input type='hidden' name='nurses_preassigned[]' value='{$row2['VAT']}'>");
						echo("<tr><td>Assistant Nurses: </td> <td><input type='checkbox' name='nurses_assigned[]' value='{$row2['VAT']}' checked><label>{$row2['name']} {$row2['VAT']}</label></td></tr>");
					}
				}
				if ($nrows3 != 0)
				{
					foreach($result3 as $row3)
					{
						echo("<tr><td>Assistant Nurses: </td> <td><input type='checkbox' name='nurse_list[]' value='{$row3['VAT']}'><label>{$row3['name']} {$row3['VAT']}</label></td></tr>");
					}
				}
				elseif ($nrows2 == 0 and $nrows3 == 0)
				{
					echo("<tr><td>ATTENTION: </td><td>No nurse/assistant available for this consultation</td></tr>");
				}
				echo("<tr><td><input type='submit' value ='Submit Information'/></td></tr>");
			echo("</form></table>");
		}
	}
	
	
	?>
	
	</body>

</html>