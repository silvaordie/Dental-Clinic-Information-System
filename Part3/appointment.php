<html>

    <body>

    <h3>Appointment Details</h3>
    <?php

    $client = $_REQUEST['client'];
    $date = $_REQUEST['date'];
    $doctor = $_REQUEST['doctor'];
    $description = $_REQUEST['description'];
	
	echo("<p>CLIENT: {$client}");
	echo("<p>DOCTOR: {$doctor}");
	echo("<p>DATE: {$date}");
	echo("<p>DESCRIPTION: {$description}");
	echo("<p><form action='newConsultation.php' method='post'>");
	echo("<input type='hidden' name='doctor' value='{$doctor}'>");
	echo("<input type='hidden' name='date' value='{$date}'>");
	echo("<input type='submit' value='Consultation Info'/>");
	echo("</form></p>");
	
	
	?>
	
	</body>

</html>