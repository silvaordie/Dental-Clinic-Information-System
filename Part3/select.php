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
$VAT = $_REQUEST['VAT'];

$Name = $_REQUEST['Name'];
$Adress = $_REQUEST['Adress'];
$sql = "SELECT VAT, name FROM client WHERE client.VAT LIKE '%$VAT%' and client.name LIKE '%$Name%' and client.street LIKE '%$Adress%'";
echo("<p>$sql</p>");
$result = $connection->query($sql);
$nrows = $result->rowCount();
if ($nrows == 0)
{
echo("<p>There is no client with such info.</p>");
}
else
{
    foreach($result as $row)
    {
        echo("<p>Client: $row['name'] VAT: $row['VAT']</p>");
    }
}
 $connection = null;
?>
</body>
</html>
