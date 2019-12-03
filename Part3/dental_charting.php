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

    $date = $_REQUEST['date'];
    $doctor = $_REQUEST['doctor'];
    $name = $_REQUEST['name'];


    $measure = array
    (
    array(0,0,0),
    array(0,0,0),

    );
    $description = array
    (
    array(' ',' ',' '),
    array(' ',' ',' '),

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
            echo("<td>{$row['name']}</td> <td>{$row['quadrant']} </td> <td>{$row['number']} </td>");
            echo("<td>  <input type='text' name='description[{$row['quadrant']}][{$row['number']}]'/>  </td>");
            echo("<td>  <input type='number' step ='0.1' name='measure[{$row['quadrant']}][{$row['number']}]' min = '0'/>  </td>");
            echo("<input type='hidden' value='$doctor' name='doctor' >");
            echo("<input type='hidden' value='$name' name='name' >");
            echo("<input type='hidden' value='$date' name='date' >");
            echo(" </tr>");

        }
        echo("</table> <p><input type='submit' value='new measure'> </form>");
    }

    $description = $_REQUEST['description'];
    $measure = $_REQUEST['measure'];
    $desc = 'default';
  
    $sql = "insert into procedure_in_consultation values('$name','$doctor','$date','$desc ')";
    $connection->exec($sql);


    $connection->beginTransaction();
    
    for($i=1;$i<=2;$i++){
        for($j=1;$j<=3;$j++){
            if(!empty($measure[$i][$j])){
                $sql = "insert into procedure_charting values ('$name', '$doctor', '$date','$i','$j','{$description[$i][$j]}','{$measure[$i][$j]}')";
                $connection->exec($sql); 
            }
        }
    } 

    $connection->commit();
    $connection = null;
 
    ?>




    </body>


</html>