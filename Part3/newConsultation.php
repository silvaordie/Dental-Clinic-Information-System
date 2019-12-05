<html>

    <body>

    <h3>Update Consultation Information</h3>
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
	
	$result = $connection->prepare("SELECT * FROM consultation WHERE VAT_doctor = ? and date_timestamp = ?");
	$result->execute(array($doctor, $date));
	$error = $result->errorInfo();
	if ($error[1] != ''){
		echo("<p>Error: {$error[2]}</p>");
	}

	$nrows = $result->rowCount();
	
	// Get nurses already assigned to this consultation
	$result2 = $connection->prepare("SELECT employee.name AS name, employee.VAT AS VAT FROM consultation_assistant AS ca, employee WHERE ca.VAT_doctor = ? and ca.date_timestamp = ? and ca.VAT_nurse = employee.VAT");
	$result2->execute(array($doctor, $date));

	$error2 = $result2->errorInfo();
	if ($error2[1] != ''){
		echo("<p>Error: {$error2[2]}</p>");
	}
	$nrows2 = $result2->rowCount();
	
	// Get nurses available for the desired timestamp
	$result3 = $connection->prepare("SELECT employee.name AS name, employee.VAT AS VAT FROM nurse, employee WHERE nurse.VAT NOT IN (SELECT VAT_nurse FROM consultation_assistant WHERE date_timestamp = ?) AND nurse.VAT = employee.VAT");
	$result3->execute(array($date));

	$error3 = $result3->errorInfo();
	if ($error3[1] != ''){
		echo("<p>Error: {$error3[2]}</p>");
	}
	$nrows3 = $result3->rowCount();
	
	//Get diagnostic codes already assigned to this consultation
	$result_consult_diagnostic = $connection->prepare("SELECT ID FROM consultation_diagnostic WHERE VAT_doctor = ? and date_timestamp = ?");
	$result_consult_diagnostic->execute(array($doctor,$date));

	$error4 = $result_consult_diagnostic->errorInfo();
	if ($error4[1] != ''){
		echo("<p>Error: {$error4[2]}</p>");
	}

	$nrows_consult_diagnostic = $result_consult_diagnostic->rowCount();
	
	// Get diagnostic codes
	$result_diagcodes = $connection->prepare("SELECT ID FROM diagnostic_code WHERE ID NOT IN (SELECT ID FROM consultation_diagnostic WHERE VAT_doctor = ? and date_timestamp = ?)");
	$result_diagcodes->execute(array($doctor,$date));
	$error5 = $result_diagcodes->errorInfo();
	if ($error5[1] != ''){
		echo("<p>Error: {$error5[2]}</p>");
	}
	$nrows_diagcodes = $result_diagcodes->rowCount();

	// Get medication
	$sql5 = "SELECT * FROM medication";
	$result_medication = $connection->query($sql5);
	$nrows_medication = $result_medication->rowCount();
	foreach($result_medication as $meds)
	{
		$med_array[] = array("name" => $meds['name'], "lab" => $meds['lab']);
	}	
		
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
			foreach($result3->fetchAll(PDO::FETCH_ASSOC) as $row3)
			{
				echo("<tr><td>Assistant Nurses: </td> <td><input type='checkbox' name='nurse_list[]' value='{$row3['VAT']}'><label>{$row3['name']} {$row3['VAT']}</label></td></tr>");
			}
		}
		else
		{
			echo("<tr><td>ATTENTION: </td><td>No nurse/assistant available for this consultation</td></tr>");
		}
		foreach($result_diagcodes->fetchAll(PDO::FETCH_ASSOC) as $diagnostic)
		{
			// check list of diagnostic codes
			$id = $diagnostic['ID'];
			echo("<tr><td>Diagnostic Code: </td> <td><input type='checkbox' name='codes[]' value='{$diagnostic['ID']}'><label>{$diagnostic['ID']}</label></td>");
			// check list of medication per diagnostic
			if ($nrows_medication != 0)
			{
				echo("<td>Associated Prescriptions: </td></tr>");
				foreach($med_array as $med)
				{
					$med_name = $med['name'];
					$med_lab = $med['lab'];
					$value = serialize($med);
					echo("<tr><td></td><td></td><td></td> <td><input type='checkbox' name='meds_id[$id][]' value='$value'><label>{$med_name} {$med_lab}</label></td>");
					echo("<td></td><td>Dosage:</td> <td><input type='text' name='dosage[$id][$med_name][$med_lab]'/></td>");
					echo("<td>Description:</td> <td><input type='text' name='description[$id][$med_name][$med_lab]'/></td></tr>");
				}
			}
			else
			{
				echo("<td>No Medication on the DataBase</td></tr>");
			}
		}
		echo("<tr><td><input type='submit' value ='Submit Information'/></td></tr>");
		echo("</form></table>");
	}
	else
	{
		foreach($result->fetchAll(PDO::FETCH_ASSOC) as $row)
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
					foreach($result2->fetchAll(PDO::FETCH_ASSOC) as $row2)
					{
						echo("<input type='hidden' name='nurses_preassigned[]' value='{$row2['VAT']}'>");
						echo("<tr><td>Assistant Nurses: </td> <td><input type='checkbox' name='nurses_assigned[]' value='{$row2['VAT']}' checked><label>{$row2['name']} {$row2['VAT']}</label></td></tr>");
					}
				}
				if ($nrows3 != 0)
				{
					foreach($result3->fetchAll(PDO::FETCH_ASSOC) as $row3)
					{
						echo("<tr><td>Assistant Nurses: </td> <td><input type='checkbox' name='nurse_list[]' value='{$row3['VAT']}'><label>{$row3['name']} {$row3['VAT']}</label></td></tr>");
					}
				}
				elseif ($nrows2 == 0 and $nrows3 == 0)
				{
					echo("<tr><td>ATTENTION: </td><td>No nurse/assistant available for this consultation</td></tr>");
				}
				// already created diagnosis
				if($nrows_consult_diagnostic != 0)
				{
					foreach($result_consult_diagnostic->fetchAll(PDO::FETCH_ASSOC) as $diagnostic)
					{
						// check list of diagnostic codes
						$id = $diagnostic['ID'];
						echo("<input type='hidden' name='preassigned_codes[]' value='{$diagnostic['ID']}'>");
						echo("<tr><td>Diagnostic Code: </td> <td><input type='checkbox' name='assigned_codes[]' value='{$diagnostic['ID']}' checked><label>{$diagnostic['ID']}</label></td>");
						echo("<td>Associated Prescriptions: </td></tr>");
						// find medication already prescribed
						$result_medication2 = $connection->prepare("SELECT * FROM prescription WHERE VAT_doctor = ? AND date_timestamp = ? AND ID = ?");
						$result_medication2->execute(array($doctor,$date,$id));
						$error6 = $result_medication2->errorInfo();
						if ($error6[1] != ''){
							echo("<p>Error: {$error6[2]}</p>");
						}

						$nrows_medication2 = $result_medication2->rowCount();
						if($nrows_medication2 != 0)
						{
							foreach($result_medication2->fetchAll(PDO::FETCH_ASSOC) as $med)
							{
								$med_name = $med['name'];
								$med_lab = $med['lab'];
								$prevalue = array("name" => $med['name'], "lab" => $med['lab']);
								$value = serialize($prevalue);
								echo("<input type='hidden' name='meds_id_preassigned[$id][]' value='$value'>");
								echo("<tr><td></td><td></td><td></td> <td><input type='checkbox' name='meds_id_assigned[$id][]' value='$value' checked><label>{$med_name} {$med_lab}</label></td>");
								echo("<td></td><td>Dosage:</td> <td><input type='text' name='dosage[$id][$med_name][$med_lab]' value='{$med['dosage']}'/></td>");
								echo("<td>Description:</td> <td><input type='text' name='description[$id][$med_name][$med_lab]' value='{$med['description']}'/></td></tr>");
							}
						}
						// find medication not prescribed
						$result_medication2 = $connection->prepare("SELECT * FROM medication WHERE (name,lab) NOT IN (SELECT name, lab FROM prescription WHERE VAT_doctor = ? AND date_timestamp = ? AND ID = ?");
						$result_medication2->execute(array($doctor,$date,$id));
						$error7 = $result_medication2->errorInfo();
						if ($error7[1] != ''){
							echo("<p>Error: {$error7[2]}</p>");
						}

						$nrows_medication2 = $result_medication2->rowCount();
						if($nrows_medication2 != 0)
						{
							foreach($result_medication2->fetchAll(PDO::FETCH_ASSOC) as $med)
							{
								$med_name = $med['name'];
								$med_lab = $med['lab'];
								$prevalue = array("name" => $med['name'], "lab" => $med['lab']);
								$value = serialize($prevalue);
								echo("<tr><td></td><td></td><td></td> <td><input type='checkbox' name='meds_id[$id][]' value='$value'><label>{$med_name} {$med_lab}</label></td>");
								echo("<td></td><td>Dosage:</td> <td><input type='text' name='dosage[$id][$med_name][$med_lab]'/></td>");
								echo("<td>Description:</td> <td><input type='text' name='description[$id][$med_name][$med_lab]'/></td></tr>");
							}
						}
					}
				}
				// not yet created diagnosis
				foreach($result_diagcodes->fetchAll(PDO::FETCH_ASSOC) as $diagnostic)
				{
					// check list of diagnostic codes
					$id = $diagnostic['ID'];
					echo("<tr><td>Diagnostic Code: </td> <td><input type='checkbox' name='codes[]' value='{$diagnostic['ID']}'><label>{$diagnostic['ID']}</label></td>");
					// check list of medication per diagnostic
					if ($nrows_medication != 0)
					{
						echo("<td>Associated Prescriptions: </td></tr>");
						foreach($med_array as $med)
						{
							$med_name = $med['name'];
							$med_lab = $med['lab'];
							$value = serialize($med);
							echo("<tr><td></td><td></td><td></td> <td><input type='checkbox' name='meds_id[$id][]' value='$value'><label>{$med_name} {$med_lab}</label></td>");
							echo("<td></td><td>Dosage:</td> <td><input type='text' name='dosage[$id][$med_name][$med_lab]'/></td>");
							echo("<td>Description:</td> <td><input type='text' name='description[$id][$med_name][$med_lab]'/></td></tr>");
						}
					}
				}
				echo("<tr><td><input type='submit' value ='Submit Information'/></td></tr>");
			echo("</form></table>");
		}
	}
	
	
	?>
	
	</body>

</html>
