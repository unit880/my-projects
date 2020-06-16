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
						$username = $_POST['username'];
						$password = $_POST['password'];
						$confirmation = $_POST['confirmPW'];
						if (isset($_POST['isAdmin']) && $_POST['isAdmin'] === "on") {
							$isAdmin = True;
						} else {
							$isAdmin = False;
						}
						
						$isValid = true;
						
						// query to check if the username is already in the database
						$username = mysql_real_escape_string($username);
						$queryResult = runQuery("SELECT username FROM tbluser WHERE username LIKE \"$username\"");
						$usernameResult = mysql_fetch_row($queryResult);
						
						if (strlen($username) > 16 || empty($username)) {
							$isValid = false;
							echo "<h2>The username was invalid.</h2>";
						} else if ($username == $usernameResult[0]) {
							$isValid = false;
							echo "<h2>That username is already in use.</h2>";
						}
						
						if ($password != $confirmation) {
							$isValid = false;
							echo "<h2>The passwords did not match.</h2>";
						} else if (strlen($password) < 8) {
							$isValid = false;
							echo "<h2>The password cannot be less than 8 characters.</h2>";
						}
						
						if ($isValid) {
							echo "<p>Succesful</p>";
							
							$hash = sha1($password);
							$hash = mysql_real_escape_string($hash);
							$date = date('Y-m-d');
							$date = mysql_real_escape_string($date);
							
							$insertQuery = "INSERT INTO tbluser (username, password, isBanned, isAdmin, dateMade)
											VALUES (\"$username\", \"$hash\", \"" . false . "\", \"" . $isAdmin . "\", \"$date\")";
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

