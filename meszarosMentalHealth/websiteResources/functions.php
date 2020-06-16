<?php

	function runQuery($query) {
		$dbConn = mysql_connect("localhost", "jameszaros", "7234");
		$queryResult = mysql_db_query("dbmentalhealth", $query);
		mysql_close($dbConn);
		return $queryResult;
	}
	
	function printBool($boolName, $boolVal) {
		if ($boolVal) {
			return "$boolName: Yes";
		} else {
			return "$boolName: No";
		}
	}

?>
