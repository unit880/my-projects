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
						
						$isValid = true;
						
						// query to check if the username is already in the database
						$queryResult = runQuery("SELECT userID, username, password, isAdmin, isBanned FROM tbluser WHERE username LIKE \"$username\"");
						$usernameResult = mysql_fetch_assoc($queryResult);
						
						if (sha1($password) !== $usernameResult['password'] || $username !== $usernameResult['username']) {
							$isValid = false;
							echo "<h2>The username or password was invalid.</h2>";
						}
						
						if ($isValid && !$usernameResult['isBanned']) {
							echo "<h2>Successful</h2>";
							$_SESSION['user'] = $usernameResult['userID'];
							$_SESSION['admin'] = $usernameResult['isAdmin'];
						} else if ($usernameResult['isBanned']) {
							echo "<h2>You are banned!</h2>";
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
