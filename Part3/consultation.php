<html>
    <body>

    <h3>Consultation Details</h3>
    <form action='dental_charting.php' method='post'>
    <?php

    echo("<p>VAT doctor: {$_REQUEST['doctor']}");
    echo("<p>date : {$_REQUEST['date']}");
    echo("<p>SOAP_S: {$_REQUEST['soap_s']}");
    echo("<p>SOAP_O: {$_REQUEST['soap_o']}");
    echo("<p>SOAP_A: {$_REQUEST['soap_a']}");
    echo("<p>SOAP_P: {$_REQUEST['soap_p']}");

    $doctor = $_REQUEST['doctor'];
    $date = $_REQUEST['date'];
    echo("<input type='hidden' name = 'doctor' value = '$doctor'>");
    echo("<input type='hidden' name = 'date' value = '$date'>");


    ?>
        <p>
        <input type='hidden' name = 'name' value = 'd4 charting'>
        <input type='submit' value='new dental chart'>
    </form>

   


    </body>
</html>