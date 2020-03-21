<?php

class DBHandle
{
    // Credentials
    private $host = "localhost";
    private $db_name = "damianir-rosiki";
    private $username = "damianir-admin";
    private $password = "praythesun";
    public $handle;

    public function get()
    {
        $this->handle = null;
        try
        {
            $this->handle = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username, $this->password);
            $this->handle->exec("set names utf8");
        }
        catch(PDOException $exception)
        {
            echo "Database handleection error: " . $exception->getMessage();
        }
        return $this->handle;
    }
}

?>