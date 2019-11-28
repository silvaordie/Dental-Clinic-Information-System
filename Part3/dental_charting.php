<html>

    <body>
    <h3>Dental Charting  <?php echo("{$_REQUEST['date']}") ?></h3>

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

    $measure = array
    (
    array(0,0,0),
    array(0,0,0),

    );


    $sql = "SELECT * from teeth";
    $result = $connection->query($sql);
    $nrows = $result->rowCount();
    if ($nrows == 0)
    {
    echo("<p>erro!</p>");
    }
    else
    {   
        echo("<form action='dental_charting.php' method='post'> <table>");
        echo("<tr> <th>Name</th> <th>Quadrant</th> <th>Number</th> <th>Description</th> <th>Measure</th> <th></th> </tr>");
        foreach($result as $row)
        {
            //insert description array
            echo("<tr> ");
            echo("<td>{$row['name']}</td> <td><input type='hidden' name='quadrant' value='{$row['quadrant']}'>{$row['quadrant']} </td> <td><input type='hidden' name='number' value='{$row['number']}'>{$row['number']} </td>");
            echo("<td>  <input type='text' name='description'/>  </td>");
            echo("<td>  <input type='number' step ='0.1' name='measure[{$row['quadrant']}][{$row['number']}]' min = '0'/>  </td>");
            echo("<input type='hidden' value='$VAT' name='VAT' >");
            echo("<input type='hidden' value='$name' name='name' >");
            echo("<input type='hidden' value='$date_time' name='date_time' >");
            echo(" </tr>");

        }
        echo("</table> <p><input type='submit' value='new measure'> </form>");
    }

    $description = $_REQUEST['description'];
    $measure = $_REQUEST['measure'];
    $VAT = $_REQUEST['doctor'];
    $date_time = $_REQUEST['date'];
    $name = $_REQUEST['name'];
    $number = $_REQUEST['number'];
    $quadrant = $_REQUEST['quadrant'];
  
    $connection->beginTransaction();

    for($i;$i<2;$i++){
        for($j;$j<3;$j++){
            if($measure[i,j]!=0){
                $sql = "insert into procedure_charting values ('$name', '$VAT', '$date_time','$quadrant','$number','$description','{$measure[$i][$j]}')";
                $result = $connection->query($sql);                
            }
        }
    }
    $connection->commit();
 
    ?>




    </body>


</html>