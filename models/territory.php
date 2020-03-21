<?php

class Territory 
{
    private $handle;
    private $table_name = "Territory";
  
    public $id_territory;
    public $territory_name;
    public $id_continent;
    public $continent_name;

    public function __construct($db_handle)
    {
        $this->handle = $db_handle;
    }
    
    public function read()
    { 
        // Select all query
        $query = "SELECT * FROM " . $this->table_name . " ORDER BY ID_TERRITORY DESC";
        // Prepare query statement
        $stmt = $this->conn->prepare($query);
        // Execute query
        $stmt->execute();
    
        return $stmt;
    }
}

?>