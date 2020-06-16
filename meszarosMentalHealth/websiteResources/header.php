<?php
	  if (isset($_SESSION['user'])) {
		  $usernameQuery = runQuery("SELECT username FROM tbluser WHERE userID=" . $_SESSION['user'] . "");
		  $usernameQuery = mysql_fetch_row($usernameQuery);
	  }
	  
	  $headerString = "<div id=\"header\">
				<h1>Mental Health Blog</h1>
				<h2>by Jeffrey Meszaros</h2>
			</div>
		
			<div id=\"splash\"></div>
		
			<div id=\"menu\">
				<ul>
					<li class=\"first\"><a href=\"index.php\">Main Page</a></li>
					<li><a href=\"posts.php\">Post Archive</a></li>"; 
					
			if (isset($_SESSION['user'])) {		
				$headerString .= "<li><a href=\"logout.php\">Logout</a></li>
								  <li><a href=\"user.php?user=" . $usernameQuery[0] . "\">Your Profile</a></li>";
			} else {
				$headerString .= "<li><a href=\"login.php\">Login/Registration</a></li>";
			}
				
			$headerString .= "</ul>
			<div id=\"date\">" . date('F jS Y, g:i a') . "</div>
			</div>";
			
			echo $headerString;
?>
