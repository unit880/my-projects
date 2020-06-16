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
				<form method="post" action="confirmLogin.php">
					<h3>Login</h3>
					<label>Username: </label><input type="text" name="username"><br>
					<label>Password: </label><input type="password" name="password"><br>
					<button type="submit" value="Login">Login</button>
				</form>
				<hr>
				
				<form method="post" action="confirmRegistration.php">
					<h3>Register</h3>
					<label><strong>Usernames are limited to 16 characters long.</strong></label><br>
					<label>Desired Username: </label><input type="text" name="username" maxlength=16><br>
					<label><strong>Passwords must be at least 8 characters long.</strong></label><br>
					<label>Desired password: </label><input type="password" name="password"><br>
					<label>Confirm password: </label><input type="password" name="confirmPW"><br>
					<input type="checkbox" name="isAdmin"><label> Are you an admin? (For easy testing, not website functionality)</label>
					<hr>
					<button type="submit" value="Register">Register</button>
				</form>

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
