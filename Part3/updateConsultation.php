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
	echo("<p>Consultation updated: $nrows</p>");

	//nurses
	if(!empty($_REQUEST['nurses_preassigned']))
	{
		//removed nurses from consultation
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
		//nurses added to consultation
		foreach($_REQUEST['nurse_list'] as $nurse)
		{
			$sql = "INSERT INTO consultation_assistant VALUES ('$doctor', '$date', '$nurse')";
			echo("<p>$sql</p>");
			$nrows = $connection->exec($sql);
			echo("<p>New Nurses/Assistants Assigned: $nrows</p>");
		}
	}
	
	//new diagnosis
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
					echo("<p>Prescriptions added: $nrows</p>");
				}
			}
		}
	}
	
	//already assigned diagnosis
	if(!empty($_REQUEST['preassigned_codes']))
	{
		//check changes on the already assigned diagnosis
		if(!empty($_REQUEST['assigned_codes'])){
			$deletions = array_diff($_REQUEST['preassigned_codes'],$_REQUEST['assigned_codes']);}
		else{
			$deletions = $_REQUEST['preassigned_codes'];}
		//deletions
		foreach($deletions as $code)
		{
			//delete all prescriptions for this consultation_diagnostic
			$sql = "DELETE FROM prescription WHERE VAT_doctor = '$doctor' AND date_timestamp = '$date' AND ID = '$code'";
			echo("<p>$sql</p>");
			$nrows = $connection->exec($sql);
			echo("<p>Prescriptions Deleted: $nrows</p>");
			//delete consultation_diagnostic
			$sql = "DELETE FROM consultation_diagnostic WHERE VAT_doctor = '$doctor' AND date_timestamp = '$date' AND ID = '$code'";
			echo("<p>$sql</p>");
			$nrows = $connection->exec($sql);
			echo("<p>Diagnosis Deleted: $nrows</p>");
		}
		//updates on preassigned diagnosis
		$meds_assigned = $_REQUEST['meds_id_assigned'];
		$meds_preassigned = $_REQUEST['meds_id_preassigned'];
		foreach($_REQUEST['assigned_codes'] as $code)
		{
			if(!empty($meds_preassigned[$code]))
			{
				if(!empty($meds_assigned[$code])){
					//updates to be made
					foreach($meds_assigned[$code] as $update)
					{
						$med = unserialize($update);
						$name = $med['name'];
						$lab = $med['lab'];
						$dosage = $_REQUEST['dosage'];
						$dosage = $dosage[$code][$name][$lab];
						$description = $_REQUEST['description'];
						$description = $description[$code][$name][$lab];
						$sql = "UPDATE prescription SET dosage = '$dosage', description = '$description' WHERE name = '$name' AND lab = '$lab' AND VAT_doctor = '$doctor' AND date_timestamp = '$date' AND ID = '$code'";
						echo("<p>$sql</p>");
						$nrows = $connection->exec($sql);
						echo("<p>Updates Completed: $nrows</p>");
					}
						$deletions = array_diff($meds_preassigned[$code],$meds_assigned[$code]);}
				else{
					$deletions = $meds_preassigned[$code];}
				//deletions to be made
				foreach($deletions as $deletion)
				{
					$med = unserialize($deletion);
					$name = $med['name'];
					$lab = $med['lab'];
					$sql = "DELETE FROM prescription WHERE name = '$name' AND lab = '$lab' AND VAT_doctor = '$doctor' AND date_timestamp = '$date' AND ID = '$code'";
					echo("<p>$sql</p>");
					$nrows = $connection->exec($sql);
					echo("<p>Prescriptions Deleted: $nrows</p>");
				}
			}
			//insertions of meds for this diagnostic
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
					echo("<p>Prescriptions added: $nrows</p>");
				}
			}
		}
	}
	
	?>
	
	</body>

</html>
