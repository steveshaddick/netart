<?php

/**
 * @title 	MySQL Utility
 * @author	Steve Shaddick
 * @version 1.0
 *
 * @description 	A class for interfacing MySQL with PHP
					
 * @tags database, mysql, security, utility 
 *
 *
 */
 
class MySQLUtility {
	
	public $error = '';
	public $dbIP = '';
	public $dbUsername = '';
	public $dbPassword = '';
	public $dbName = '';
	
	public $sqlConn = '';
	public $isConnected = false;
	
	
	/**********************
	 * @function	constructor
	 * @input	$dbUsername (string) : mySQL username
				$dbPassword (string) : mySQL password
				$dbIP (string) : mySQL location
				$dbName (string) : mySQL database name
				
	 */
	public function __construct($dbUsername, $dbPassword, $dbIP, $dbName)
	{
		$this->dbUsername = $dbUsername;
		$this->dbPassword = $dbPassword;
		$this->dbIP = $dbIP;
		$this->dbName = $dbName;

		$this->sqlConn = new mysqli($this->dbIP, $this->dbUsername, $this->dbPassword, $this->dbName);

		/* check connection */
		if ($this->sqlConn->connect_errno) {
			$this->isConnected = false;
		} else {
			$this->isConnected = true;
		}
		
	}
	
	/**********************
	 * @function	sendQuery
	 * @input	$query (string) : the mysql query
				$closeConnection (string) : whether to close the connection after executing the query (default: true)
				
	 * @output	Returns an array of rows and column names 
	 			or false if something fails 
				or true if the query returns === true
	 */
	public function sendQuery($query)
	{

		if (!$this->isConnected) {
			$ret = false;
		} else {
			//good to send the query
			
			$result = $this->sqlConn->query($query);
			
			$ret = array();
			if ($result === false) {
				$ret = false;
			} else {
				if ($result !== true) {
					while($row = $result->fetch_assoc())
					{
						//build the return array.  An empty result will return an array of count 0
						$ret[] = $row;
					}
				} else {
					$ret = true;
				}
			}
			
			return $ret;
		}
	}
	
	/**********************
	 * @function	cleanMySQL
	 * @input	$secret (string) : the application secret
				$redirect (string) : the application home url 
				
	 * @output	Redirects if not a valid facebook request
	 */
	public function cleanString($value)
	{
		if (!$this->isConnected) {
			return false;
		} else {
			return sprintf("%s", $this->sqlConn->real_escape_string($value));
		}
	}
	
	/**********************
	 * @function	encodeJSON
	 * @input	$data (array) : an array that conforms to the return data from this class
				
	 * @output	A JSON-encoded string
	 */
	public function encodeJSON($data)
	{
		$isData = false;
		
		$str = '{';
		
		//this might have to be altered to escape quotes
		$str.= '"rows": [';
		foreach ($data as $row)
		{
			$isData = true;
			$str.=' { ';
			foreach ($row as $key=>$value)
			{
				$str.='"'.$key.'": "'.$value.'",';
			}
			$str = substr($str, 0, strlen($str) -1);
			$str.=' },';
		}
		if ($isData) {
			$str = substr($str, 0, strlen($str) -1);
		}
		
		$str.= ']';
		
		$str.= '}';
		
		return $str;
		
	}
	
	/**********************
	 * @function	closeConnection
	 * @input	Nothing			
	 * @output	Closes the mySQL connection if open
	 */
	public function closeConnection()
	{
		if ($this->sqlConn != '') {
			$this->sqlConn->close();
			$this->sqlConn = '';
		}
	}
	
	function __destruct()
	{
		$this->closeConnection();
	}


}

?>