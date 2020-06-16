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
					if (isset($_GET['user'])) {
						$username = $_GET['user'];
						
						$isValid = true;
						
						// query to check if the username is already in the database
						$queryResult = runQuery("SELECT userID, username, isAdmin, isBanned, bioContent, dateMade FROM tbluser WHERE username LIKE \"$username\"");
						$usernameResult = mysql_fetch_assoc($queryResult);
						
						if (!empty($usernameResult)) {
							echo "<h2>" . $usernameResult['username'] . "</h2>";
							echo "<h2>Signed up on: " . date('F jS Y', strtotime($usernameResult['dateMade'])) . "</h2>";
							if ($usernameResult['bioContent'] != NULL) {
								echo "<p>Bio: " . $usernameResult['bioContent'] . "</p>";
							} else {
								echo "<p>This user does not have a bio.</p>";
							}
							
							if (isset($_SESSION['user'])) {
								if ($usernameResult['userID'] === $_SESSION['user']) {
									echo "<form method=\"post\" action=\"updateBio.php\">
											<textarea maxlength=\"255\" style=\"width:300px; height:100px;\" name=\"bioContent\"></textarea>
											<button type=\"submit\" value=\"Submit New Bio\">Submit New Bio</button>
										  </form>";
								}
							}
							
							echo printBool("Is an Admin", $usernameResult['isAdmin']) . "<br>";
							echo printBool("Is Banned", $usernameResult['isBanned']);
							
							if (isset($_SESSION['user'])) {
								if ($usernameResult['userID'] != $_SESSION['user'] && $_SESSION['admin'] == True && !$usernameResult['isBanned']) {
									echo "<form action=\"banUser.php\" method=\"post\"> 
											<input type=\"hidden\" value=\"" . $usernameResult['userID'] . "\" name=\"ID\">
											<input type=\"hidden\" value=\"" . True . "\" name=\"banOrUnban\">
											<button type=\"submit\" value=\"Ban User\">Ban User</button>
										  </form>";
								} else if ($usernameResult['userID'] != $_SESSION['user'] && $_SESSION['admin'] == True && $usernameResult['isBanned']) {
									echo "<form action=\"banUser.php\" method=\"post\"> 
											<input type=\"hidden\" value=\"" . $usernameResult['userID'] . "\" name=\"ID\">
											<input type=\"hidden\" value=\"" . False . "\" name=\"banOrUnban\">
											<button type=\"submit\" value=\"Ban User\">Unban User</button>
										</form>";
								}
								
								if ($usernameResult['userID'] != $_SESSION['user'] && $_SESSION['admin'] == True && !$usernameResult['isAdmin']) {
									echo "<form action=\"makeAdmin.php\" method=\"post\"> 
											<input type=\"hidden\" value=\"" . $usernameResult['userID'] . "\" name=\"ID\">
											<input type=\"hidden\" value=\"" . True . "\" name=\"adminOrNot\">
											<button type=\"submit\" value=\"Make Admin\">Make Admin</button>
										  </form>";
								} else if ($usernameResult['userID'] != $_SESSION['user'] && $_SESSION['admin'] == True && $usernameResult['isAdmin']) {
									echo "<form action=\"makeAdmin.php\" method=\"post\"> 
											<input type=\"hidden\" value=\"" . $usernameResult['userID'] . "\" name=\"ID\">
											<input type=\"hidden\" value=\"" . False . "\" name=\"adminOrNot\">
											<button type=\"submit\" value=\"Demote\">Demote</button>
										</form>";
								}
							}
						} else {
							echo "<h2>No users were found by that name.</h2>";
						}
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
