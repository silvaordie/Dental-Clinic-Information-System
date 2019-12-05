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
	
	$result = $connection->prepare("UPDATE consultation SET SOAP_S = ?, SOAP_O = ?, SOAP_A = ?, SOAP_P = ? WHERE VAT_doctor = ? and date_timestamp = ?");
	$result->execute(array($s,$o,$a,$p,$doctor,$date));

	$error = $result->errorInfo();
	if ($error[1] != ''){
		echo("<p>Error: {$error[2]}</p>");
	}
	else{
		echo("<p>Consultation updated</p>");
	}

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
			$result = $connection->prepare("DELETE FROM consultation_assistant WHERE VAT_doctor = ? and date_timestamp = ? and VAT_nurse = ?");
			$result->execute(array($doctor,$date,$deletion));
			$error = $result->errorInfo();
			if ($error[1] != ''){
				echo("<p>Error: {$error[2]}</p>");
			}
			else{
				echo("<p>Assistants Removed</p>");
			}
		}
	}
	if(!empty($_REQUEST['nurse_list']))
	{
		//nurses added to consultation
		foreach($_REQUEST['nurse_list'] as $nurse)
		{
			$result = $connection->prepare("INSERT INTO consultation_assistant VALUES (?, ?, ?)");
			$result->execute(array($doctor,$date,$nurse));
			$error = $result->errorInfo();
			if ($error[1] != ''){
				echo("<p>Error: {$error[2]}</p>");
			}
			else{
				echo("<p>New Nurses/Assistants Assigned</p>");
			}
		}
	}
	
	//new diagnosis
	if(!empty($_REQUEST['codes']))
	{
		foreach($_REQUEST['codes'] as $code)
		{
			$result = $connection->prepare("INSERT INTO consultation_diagnostic VALUES (?, ?, ?)");
			$result->execute(array($doctor,$date,$code));
			$error = $result->errorInfo();
			if ($error[1] != ''){
				echo("<p>Error: {$error[2]}</p>");
			}
			else{
				echo("<p>Diagnosis Created</p>");
			}

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
					
					$result = $connection->prepare("INSERT INTO prescription VALUES (?, ?, ?, ?, ?, ?, ?)");
					$result->execute(array($name,$lab,$doctor,$date,$code,$dosage,$description));
					$error = $result->errorInfo();
					if ($error[1] != ''){
						echo("<p>Error: {$error[2]}</p>");
					}
					else{
						echo("<p>Prescriptions added</p>");
					}
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
			$result = $connection->prepare("DELETE FROM prescription WHERE VAT_doctor = ? AND date_timestamp = ? AND ID = ?");
			$result->execute(array($doctor,$date,$code));
			$error = $result->errorInfo();
			if ($error[1] != ''){
				echo("<p>Error: {$error[2]}</p>");
			}
			else{
				echo("<p>Prescriptions Deleted</p>");
			}
			
			//delete consultation_diagnostic
			$result = $connection->prepare("DELETE FROM consultation_diagnostic WHERE VAT_doctor = ? AND date_timestamp = ? AND ID = ?");
			$result->execute(array($doctor,$date,$code));
			$error = $result->errorInfo();
			if ($error[1] != ''){
				echo("<p>Error: {$error[2]}</p>");
			}
			else{
				echo("<p>Diagnosis Deleted</p>");
			}
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

						$result = $connection->prepare("UPDATE prescription SET dosage = ?, description = ? WHERE name = ? AND lab = ? AND VAT_doctor = ? AND date_timestamp = ? AND ID = ?");
						$result->execute(array($dosage,$description,$name,$lab,$doctor,$date,$code));
						$error = $result->errorInfo();
						if ($error[1] != ''){
							echo("<p>Error: {$error[2]}</p>");
						}
						else{
							echo("<p>Updates Completed</p>");
						}
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

					
					$result = $connection->prepare("DELETE FROM prescription WHERE name = ? AND lab = ? AND VAT_doctor = ? AND date_timestamp = ? AND ID = ?");
					$result->execute(array($name,$lab,$doctor,$date,$code));
					$error = $result->errorInfo();
					if ($error[1] != ''){
						echo("<p>Error: {$error[2]}</p>");
					}
					else{
						echo("<p>Prescriptions Deleted</p>");
					}
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

					$result = $connection->prepare("INSERT INTO prescription VALUES (?, ?, ?, ?, ?,?,?)");
					$result->execute(array($name,$lab,$doctor,$date,$code,$dosage,$description));
					$error = $result->errorInfo();
					if ($error[1] != ''){
						echo("<p>Error: {$error[2]}</p>");
					}
					else{
						echo("<p>Prescriptions added</p>");
					}
				}
			}
		}
	}
	
	?>
	
	</body>

</html>
