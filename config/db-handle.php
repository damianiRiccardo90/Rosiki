<?php

class DBHandle
{
    // Credentials
    private $host = "localhost";
    private $db_name = "damianir-rosiki";
    private $username = "damianir-admin";
    private $password = "praythesun";
    public $conn;

    public function get()
    {
        $this->conn = null;
        try
        {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username, $this->password);
            $this->conn->exec("set names utf8");
        }
        catch(PDOException $exception)
        {
            echo "Database connection error: " . $exception->getMessage();
        }
        return $this->conn;
    }
}

?>