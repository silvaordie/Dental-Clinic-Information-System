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
	

	$result = $connection->prepare("INSERT INTO consultation VALUES (?, ?, ?, ?, ?, ?)");
	$result->execute(array($doctor,$date,$s,$o,$a,$p));

	$error = $result->errorInfo();
	if ($error[1] != ''){
		echo("<p>Error: {$error[2]}</p>");
	}
	else
	{
		echo("<p>Consultation Created</p>");
	}


	if(!empty($_REQUEST['nurse_list']))
	{
		foreach($_REQUEST['nurse_list'] as $nurse)
		{	
			$result = $connection->prepare("INSERT INTO consultation_assistant VALUES (?, ?, ?)");
            $result->execute(array($doctor,$date,$nurse));

            $error = $result->errorInfo();
            if ($error[1] != ''){
                echo("<p>Error: {$error[2]}</p>");
			}
			else
			{
				echo("<p>Nurses/Assistants Assigned</p>");
			}
		}
	}
	
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
			else
			{
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

					$result = $connection->prepare("INSERT INTO prescription VALUES (?, ?, ?,?, ?,?,?)");
					$result->execute(array($name,$lab,$doctor,$date,$code,$dosage,$description));
		
					$error = $result->errorInfo();
					if ($error[1] != ''){
						echo("<p>Error: {$error[2]}</p>");
					}
					else
					{
						echo("<p>Prescription Created</p>");
					}

				}
			}
		}
	}
	
	?>
	
	</body>

</html>
