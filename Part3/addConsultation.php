<html>

    <body>

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
	
	?>
	
	</body>

</html>