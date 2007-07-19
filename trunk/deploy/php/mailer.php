<?php
/*
 * Flash Contact Form Data Conduit - 02.05
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
header("Pragma: no-cache");
header("Cache-Control: no-cache, must-revalidate");
header('Expires: -1');
$to 		= "info@sekati.com";
$subject 	= "Message from Sekati.com Visitor";
$timestamp 	= date("d/m/y @ g:i.s a");
$ip			= getenv("REMOTE_ADDR");
$src		= gethostbyaddr($ip);
$submit 	= $_POST["submit"];
$name 		= stripslashes($_POST["name"]);
$company 	= stripslashes($_POST["company"]);
$email 		= stripslashes($_POST["email"]);
$site 		= stripslashes($_POST["site"]);
$phone 		= stripslashes($_POST["phone"]);
$msg	 	= stripslashes($_POST["message"]);

$message  ="----------------------------------------------------------------------------\r\n";
$message .= "SEKATI VISITOR MESSAGE\r\n";
$message .="----------------------------------------------------------------------------\r\n";
$message .="NAME      	$name\r\n";
$message .="FROM	   	$email\r\n";
if($company){ $message .="COMPANY   	$company\r\n"; }
if($phone)	{ $message .="PHONE     	$phone\r\n"; }
if($site)	{ $message .="SITE	     	$site\r\n"; }
$message .="----------------------------------------------------------------------------\r\n";
$message .="MESSAGE\r\n$msg\r\n";
$message .="----------------------------------------------------------------------------\r\n";
$message .="RECIEVED ON $timestamp FROM ".$src."\r\n";
$message .="----------------------------------------------------------------------------\r\n";

$headers = "From: $name <$email>\r\n";
$headers .= "MIME-Version: 1.0\r\n";
$headers .= "Content-type: text/plain; charset=iso-8859-1\r\n";
$headers .= "X-Originating-IP: [".$ip."]\r\n";
$headers .= "X-Mailer: Sekati Flash Web Form / PHP " . phpversion() . "\r\n"; 

// SUBMITTED?
if ($submit && $name && $email && $msg) { 
	mail($to, $subject, $message, $headers);
	printf("rsp=true");
} else {
	printf("rsp=false");
}
// eof
?>
