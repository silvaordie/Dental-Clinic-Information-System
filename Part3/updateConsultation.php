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
	
    $date = $_REQUEST['date'];
    $doctor = $_REQUEST['doctor'];
    $s = $_REQUEST['SOAP_S'];
    $o = $_REQUEST['SOAP_O'];
    $a = $_REQUEST['SOAP_A'];
    $p = $_REQUEST['SOAP_P'];
	
	$sql = "UPDATE consultation SET SOAP_S = '$s', SOAP_O = '$o', SOAP_A = '$a', SOAP_P = '$p' WHERE VAT_doctor = '$doctor' and date_timestamp = '$date'";
	echo("<p>$sql</p>");
	$nrows = $connection->exec($sql);
	if ($nrows != 0)
	{
		echo("<p>Consultation updated: Success</p>");
	}
	else
	{
		echo("<p>Consultation updated: Failure</p>");
	}

	if(!empty($_REQUEST['nurses_preassigned']))
	{
		if(!empty($_REQUEST['nurses_assigned']))
		{
			$deletions = array_diff($_REQUEST['nurses_preassigned'],$_REQUEST['nurses_assigned']);
		}
		else
		{
			$deletions = $_REQUEST['nurses_preassigned'];
		}
		foreach($deletions as $deletion)
		{
			$sql = "DELETE FROM consultation_assistant WHERE VAT_doctor = '$doctor' and date_timestamp = '$date' and VAT_nurse = '$deletion'";
			echo("<p>$sql</p>");
			$nrows = $connection->exec($sql);
			echo("<p>Assistants Removed: $nrows</p>");
		}
	}
	if(!empty($_REQUEST['nurse_list']))
	{
		foreach($_REQUEST['nurse_list'] as $nurse)
		{
				$sql = "INSERT INTO consultation_assistant VALUES ('$doctor', '$date', '$nurse')";
				echo("<p>$sql</p>");
				$nrows = $connection->exec($sql);
				echo("<p>New Nurses/Assistants Assigned: $nrows</p>");
		}
	}
	
	?>
	
	</body>

</html>
