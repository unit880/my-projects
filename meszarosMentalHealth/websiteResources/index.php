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
					$maxQueryResult = runQuery("SELECT MAX(postID) from tblposts");
					$maxQueryResult = mysql_fetch_row($maxQueryResult);
					
					$max = $maxQueryResult[0];
					$max = mysql_real_escape_string($max);
					$min = $maxQueryResult[0] - 5;
					$min = mysql_real_escape_string($min);
					
					$queryResult = runQuery("SELECT postID, username, postContent, dateMade FROM tblposts WHERE postID BETWEEN $min AND $max");
					
					if ($queryResult != False) {
						$rows = mysql_num_rows($queryResult);
						
						for ($i=0; $i<$rows; $i++) {
							$post = mysql_fetch_assoc($queryResult);
							$date = date("F jS Y, g:i a", strtotime($post['dateMade']));
							
							// Check to see if they're banned so if they are we can delete their posts
							$bannedQuery = runQuery("SELECT isBanned FROM tbluser WHERE username LIKE \"" . $post['username'] . "\"");
							$bannedQuery = mysql_fetch_row($bannedQuery);
							
							$postString = "<div class=\"post\">
								<div class=\"header\">
									<h3><a href=\"user.php?user=" . $post['username'] . "\">" . $post['username'] . "</a></h3>
									<div class=\"date\">" . $date . "</div>
								</div>
								<div class=\"content\">
									<p>" . $post['postContent'] . "</p>
								</div>			
								<div class=\"footer\">";
								
							if (isset($_SESSION['user'])) {
								$usernameResult = runQuery("SELECT username FROM tbluser WHERE userID LIKE \"" . $_SESSION['user'] . "\"");
								$usernameResult = mysql_fetch_row($usernameResult);
								if ($post['username'] === $usernameResult[0] || $bannedQuery[0]) {
									$postString .=	"<ul>
														<li class=\"comments\"><a href=\"deletePost.php?post=" . $post['postID'] . " \">Delete</a></li>
													</ul>";
								}
							}
								
							$postString .= "</div></div>";
							
							echo $postString;
						}
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
						<li><a href="https://mentalhealthscreening.org/">Mental Health Screenings</a></li>					</ul>
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
