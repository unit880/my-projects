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
				    $postID = $_GET['post'];
				    $postID = mysql_real_escape_string($postID);
					$queryResult = runQuery("SELECT postID FROM tblposts WHERE postID LIKE $postID");
					
					if ($queryResult == False) {
						echo "<h2>No post found</h2>";
					} else {	
						$usernameResult = runQuery("DELETE FROM tblposts WHERE postID LIKE \"" . mysql_fetch_row($queryResult)[0] . "\"");
						echo "<h2>Successful</h2>";
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
