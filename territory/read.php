<?php

// Required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
  
// Include database and object files
include_once '../config/db-handle.php';
include_once '../models/territory.php';
  
// Instantiate database and product object
$db_handle = new DBHandle()->get();
  
// Initialize object
$territory = new Territory($db_handle);
  
// Query products
$stmt = $territory->read();

// Check if more than 0 record found
$num = $stmt->rowCount();
if($num > 0)
{
    // Products array
    $territory_arr = array();
    $territory_arr["territories"] = array();
  
    // Retrieve our table contents
    // Fetch() is faster than fetchAll()
    // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
    {
        // Extract row. This will make $row['name'] to just $name only
        extract($row);
  
        $territory_item = array(
            "id_territory" => $id_territory,
            "territory_name" => $territory_name,
            "id_continent" => $id_continent,
            "continent_name" => $continent_name
        );
  
        array_push($territory_arr["territories"], $territory_item);
    }
  
    // Set response code - 200 OK
    http_response_code(200);
  
    // Show products data in json format
    echo json_encode($territory_arr);
}
else
{
    // Set response code - 404 Not found
    http_response_code(404);
  
    // Tell the user no products found
    echo json_encode(
        array("message" => "No products found.")
    );
}

?>