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
					if (isset($_SESSION['admin']) && $_SESSION['admin'] = True) {
						echo "<form action=\"confirmPost.php\" method=\"post\">
								<label>Post Content: </label><textarea style=\"width: 600px; height: 300px;\" name=\"content\" maxlength=\"1500\"></textarea>
								<br>
								<button type=\"submit\" value=\"Submit\">Submit</button>
							 </form>";
					} else {
						echo "<h2>You do not have permissions to create a post.</h2>";
					}
				?>
				<!-- primary content end -->
		
			</div>
		
			<div id="footer">
			
				Design by <a href="http://www.nodethirtythree.com/">NodeThirtyThree</a>.
			
			</div>

		</div>

	</div>

	</body>
</html>
