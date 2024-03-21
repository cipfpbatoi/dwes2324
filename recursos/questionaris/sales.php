<?php
include_once $_SERVER['DOCUMENT_ROOT'].'/load.php';

use BatBook\Sales;
const ID_USER = 9;
const ID_BOOK1 = 9;
const ID_BOOK2 = 8;
const ID_BOOK3 = 7;

$sale = new Sales(ID_BOOK1,ID_USER);
$sale->save();
$sale = new Sales(ID_BOOK2,ID_USER);
$sale->save();
$sale = new Sales(ID_BOOK3,ID_USER);
$sale->save();
$sales = Sales::getSales(9);
echo count($sales);
echo "<br>";
$sale->delete();
$sales = Sales::getSales(9);
echo count($sales);
