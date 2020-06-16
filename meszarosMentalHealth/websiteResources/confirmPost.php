<?php 
	session_start(); 
	include 'functions.php';
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--

	terrafirma1.0 by nodethirtythree design
	http://www.nodethirtythree.com

-->
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
		<title>Mental Health</title>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<link rel="stylesheet" type="text/css" href="default.css" />
	</head>
	
	<body>

	<div id="outer">

		<div id="upbg"></div>

		<div id="inner">

			<?php include 'header.php' ?>

			<div id="primarycontent">
			
				<!-- primary content start -->
				<?php
					if (!empty($_POST)) {
						$userID = $_SESSION['user'];
						$content = $_POST['content'];
						$date = date('Y:m:d H-i-s');
						
						$isValid = true;
						
						// query to check if the username is already in the database
						$userID = mysql_real_escape_string($userID);
						$queryResult = runQuery("SELECT username FROM tbluser WHERE userID LIKE \"$userID\"");
						$usernameResult = mysql_fetch_row($queryResult);
						
						if (!isset($_SESSION['user']) || !isset($_POST['content'])) {
							$isValid = false;
							echo "<h2>There was an error posting.</h2>";
						}
						
						if ($isValid) {
							echo "<p>Succesful</p>";
							
							$username = mysql_real_escape_string($usernameResult[0]);
							$content = mysql_real_escape_string($content);
							$date = mysql_real_escape_string($date);
							
							$insertQuery = "INSERT INTO tblposts (username, postContent, dateMade)
											VALUES (\"$username\", \"$content\", \"$date\")";
							$insertResult = runQuery($insertQuery);
							
						}
						
						echo "<a href=\"login.php\"><- Back</a>";
						
					} else {
						echo "<h2>No entry data found</h2>";
					}
					
				?>
				<!-- primary content end -->
		
			</div>
			
			<div id="secondarycontent">

				<!-- secondary content start -->
				
				<h3>Helpful Links</h3>
				<div class="content">
					<ul class="linklist">
						<li class="first"><a href="https://www.nimh.nih.gov/index.shtml">National Institute of Mental Health</a></li>
						<li><a href="https://mentalhealthscreening.org/">Mental Health Screenings</a></li>
					</ul>
				</div>

				<!-- secondary content end -->

			</div>
		
			<div id="footer">
			
				Design by <a href="http://www.nodethirtythree.com/">NodeThirtyThree</a>.
			
			</div>

		</div>

	</div>

	</body>
</html>
