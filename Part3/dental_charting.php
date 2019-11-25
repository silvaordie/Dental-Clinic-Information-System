<html>

    <body>
    <h3>Dental Charting</h3>

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

    $sql = "SELECT * from teeth";
    $result = $connection->query($sql);
    $nrows = $result->rowCount();
    if ($nrows == 0)
    {
    echo("<p>erro!</p>");
    }
    else
    {   
        echo("<table>");
        echo("<tr> <th>Name</th> <th>Quadrant</th> <th>Number</th> <th>Description</th> <th>Measure</th> <th></th> </tr>");
        foreach($result as $row)
        {
            echo("<tr> <form action='dental_charting.php' method='post'>");
            echo("<td>{$row['name']}</td> <td><input type='hidden' name='quadrant' value='{$row['quadrant']}'>{$row['quadrant']} </td> <td><input type='hidden' name='number' value='{$row['number']}'>{$row['number']} </td>");
            echo("<td>  <input type='text' name='description'/>  </td>");
            echo("<td>  <input type='number' step ='0.01' name='measure' min = '0'/>  </td>");
            echo("<input type='hidden' value='$VAT' name='VAT' >");
            echo("<input type='hidden' value='$name' name='name' >");
            echo("<input type='hidden' value='$date_time' name='date_time' >");

            echo("<td> <input type='submit' value='new measure'> </td>");
            echo("</form> </tr>");

        }
        echo("</table>");
    }

    $description = $_REQUEST['description'];
    $measure = $_REQUEST['measure'];
    $VAT = $_REQUEST['VAT'];
    $date_time = $_REQUEST['date_time'];
    $name = $_REQUEST['name'];
    $number = $_REQUEST['number'];
    $quadrant = $_REQUEST['quadrant'];
 /* 
    if(!empty($measure))
    {´
        $sql = "insert into procedure_charting values ('$name', '$VAT', '$date_time','$quadrant','$number','$description','$measure')";
        $result = $connection->query($sql);

    } 
 */

    ?>


    </body>


</html>