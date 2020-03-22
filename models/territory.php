<?php

class Territory 
{
    private $handle;
    private $table_name = "TERRITORY";
  
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
        $query = "SELECT * FROM " . $this->table_name . " ORDER BY ID_TERRITORY ASC";
        // Prepare query statement
        $stmt = $this->handle->prepare($query);
        // Execute query
        $stmt->execute();
    
        return $stmt;
    }

    public function create()
    {
    	// Query to insert record
        $query = "INSERT INTO " . $this->table_name . 
                 "VALUES (:id_territory, :territory_name, :id_continent, :continent_name)";
    
        // Prepare query
        $stmt = $this->handle->prepare($query);
    
        // Sanitize
        $this->id_territory = htmlspecialchars(strip_tags($this->id_territory));
        $this->territory_name = htmlspecialchars(strip_tags($this->territory_name));
        $this->id_continent = htmlspecialchars(strip_tags($this->id_continent));
        $this->continent_name = htmlspecialchars(strip_tags($this->continent_name));
    
        // Bind values
        $stmt->bindParam(":id_territory", $this->id_territory);
        $stmt->bindParam(":territory_name", $this->territory_name);
        $stmt->bindParam(":id_continent", $this->id_continent);
        $stmt->bindParam(":continent_name", $this->continent_name);
    
        // Execute query
        if($stmt->execute()){
            return true;
        }
    
        return false;
    }
}

?>