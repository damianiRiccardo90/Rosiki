<?php

// Required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
  
// Get database connection
include_once '../config/db-handle.php';
  
// Include object file
include_once '../models/territory.php';
  
$db_handle = (new DBHandle())->get();
  
// Initialize object
$territory = new Territory($db_handle);
  
// Get posted data
$data = json_decode(file_get_contents("php://input"));
  
// Make sure data is not empty
if(
    !empty($data->id_territory) &&
    !empty($data->territory_name) &&
    !empty($data->id_continent) &&
    !empty($data->continent_name)
)
{
    // Set territory property values
    $territory->id_territory = $data->id_territory;
    $territory->territory_name = $data->territory_name;
    $territory->id_continent = $data->id_continent;
    $territory->continent_name = $data->continent_name;
  
    // Create the territory
    if($territory->create())
    {
        // Set response code - 201 created
        http_response_code(201);
  
        // Tell the user
        echo json_encode(array("message" => "Territory was created."));
    }
    else // If unable to create the product, tell the user
    {
        // Set response code - 503 service unavailable
        http_response_code(503);
  
        // Tell the user
        echo json_encode(array("message" => "Unable to create territory."));
    }
}
else // Tell the user data is incomplete
{
    // Set response code - 400 bad request
    http_response_code(400);
  
    // Tell the user
    echo json_encode(array("message" => "Unable to create territory. Data is incomplete."));
}

?>