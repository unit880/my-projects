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
					$minQueryResult = runQuery("SELECT MIN(postID) from tblposts");
					$maxQueryResult = mysql_fetch_array($maxQueryResult);
					$minQueryResult = mysql_fetch_array($minQueryResult);
					
					if (!isset($_POST['ID']) || $_POST['ID'] > $maxQueryResult[0]) {
						$shownIDs = $maxQueryResult[0];
					} else if ($_POST['ID'] < $minQueryResult[0]) {
						$shownIDs = $minQueryResult[0] + 10;
					} else {
						$shownIDs = $_POST['ID'];
					}
					
					$max = $shownIDs;
					$max = mysql_real_escape_string($max);
					$min = $shownIDs - 10;
					$min = mysql_real_escape_string($min);
					
					$queryResult = runQuery("SELECT postID, username, postContent, dateMade FROM tblposts WHERE postID BETWEEN $min AND $max");
					$postIDs = array();
					
					if ($queryResult != False) {
						$rows = mysql_num_rows($queryResult);
						
						
						for ($i=0; $i<$rows; $i++) {
							$post = mysql_fetch_assoc($queryResult);
							$date = date("F jS Y, g:i a", strtotime($post['dateMade']));
							$postIDs[$i] = $post['postID'];
							
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
					
					if (!in_array($minQueryResult[0], $postIDs)) {
						$prev = $shownIDs - 10;
						echo "<form action=\"posts.php\" method=\"post\"> 
								<input type=\"hidden\" value=\"$prev\" name=\"ID\">
								<button type=\"submit\" value=\"<- Prev\"><- Prev</button>
							  </form>";
					}
					
					if (isset($_SESSION['admin']) && $_SESSION['admin'] == True) {
						echo "<form action=\"createPost.php\" method=\"post\"> 
								<button type=\"submit\" value=\"Create Post\">Create Post</button>
					 	      </form>";
					}
					
					if (!in_array($maxQueryResult[0], $postIDs)) {
						$next = $shownIDs + 10;
						echo "<form action=\"posts.php\" method=\"post\"> 
								<input type=\"hidden\" value=\"$next\" name=\"ID\">
								<button type=\"submit\" value=\"Next - >\">Next -></button>
							  </form>";
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
