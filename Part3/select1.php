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
$VAT = $_REQUEST['VAT'];
$Name = $_REQUEST['Name'];
$Adress = $_REQUEST['Adress'];
$sql = "SELECT VAT, name FROM client WHERE client.VAT LIKE '%$VAT%' and client.name LIKE '%$Name%' and client.street LIKE '%$Adress%'";
$result = $connection->query($sql);
$nrows = $result->rowCount();
echo("<p>$nrows</p>");
if ($nrows == 0)
{
echo("<p>There is no account with such number.</p>");
}
else
{
$row = $result->fetch();
$balance = $row['name'];
echo("<p>The balance of $account_number is: $balance</p>");
}
 $connection = null;
?>
 </body>
</html>
