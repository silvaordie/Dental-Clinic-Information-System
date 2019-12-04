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
	
	$sql = "INSERT INTO consultation VALUES ('$doctor', '$date', '$s', '$o', '$a', '$p')";
	echo("<p>$sql</p>");
	$nrows = $connection->exec($sql);
	echo("<p>Consultations Created: $nrows</p>");

	
	if(!empty($_REQUEST['nurse_list']))
	{
		foreach($_REQUEST['nurse_list'] as $nurse)
		{
			$sql = "INSERT INTO consultation_assistant VALUES ('$doctor', '$date', '$nurse')";
			echo("<p>$sql</p>");
			$nrows = $connection->exec($sql);
			echo("<p>Nurses/Assistants Assigned: $nrows</p>");
		}
	}
	
	if(!empty($_REQUEST['codes']))
	{
		foreach($_REQUEST['codes'] as $code)
		{
			$sql = "INSERT INTO consultation_diagnostic VALUES ('$doctor', '$date', '$code')";
			echo("<p>$sql</p>");
			$nrows = $connection->exec($sql);
			echo("<p>Diagnosis Created: $nrows</p>");
			//insert medication for each diagnosis
			$med_id = $_REQUEST['meds_id'];
			if(!empty($med_id[$code]))
			{
				foreach($med_id[$code] as $med)
				{
					$med = unserialize($med);
					$name = $med['name'];
					$lab = $med['lab'];
					$dosage = $_REQUEST['dosage'];
					$dosage = $dosage[$code][$name][$lab];
					$description = $_REQUEST['description'];
					$description = $description[$code][$name][$lab];
					$sql = "INSERT INTO prescription VALUES ('$name', '$lab', '$doctor', '$date', '$code', '$dosage', '$description')";
					echo("<p>$sql</p>");
					$nrows = $connection->exec($sql);
					echo("<p>Prescriptions: $nrows</p>");
				}
			}
		}
	}
	
	?>
	
	</body>

</html>
