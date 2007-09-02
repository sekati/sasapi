<?php
/*
 * Unit Test Browser - Created on Sep 2, 2007
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
///////////////////////////////////////////////////////
// SETUP
header('Content-type: text/xml');
header('Cache-Control: no-cache, must-revalidate');
header('Pragma: no-cache');
header('Expires: -1');
error_reporting(E_ALL ^ E_NOTICE);

// --- CONFIG ---
$root = ".;
$appName = "Sekati Unit Test Browser // jason m horwitz | sekati.com";
// --- CONFIG ---
$path = reverse_strrchr($_SERVER['SCRIPT_FILENAME'],'/',0)."/".$root;
$self   = $_SERVER['SCRIPT_NAME'];
$edit	= $_GET['c'];
//
///////////////////////////////////////////////////////
// TOOLKIT

// REVERSE STRRRCHR (return everything up to last occurance of $needle + $trail num) | usage: $ns = reverse_strrchr($_SERVER["SCRIPT_URI"], "/", 1);
function reverse_strrchr($haystack, $needle, $trail) {
   return strrpos($haystack, $needle) ? substr($haystack, 0, strrpos($haystack, $needle) + $trail) : false;
}

// READ FILE
function read_file($file) {
	$fp = fopen($file, "r");
	$content = fread($fp, filesize($file));
	fclose($fp);
	return $content;
}

// INDEX DIR
function indexXML() {
	global $path, $header, $footer, $self;
	$str = $header;
	if ($dir = @opendir($path)) {
		while (false !== ($item = readdir($dir))) {  
			if (eregi(".xml", $item)) {
				$file = $path.'/'.$item;
				$name = substr($item, 0, -4);
				$time = date("D, d M Y H:i:s", filemtime($file));
				$size = filesize($file);
				$url = $_SERVER['SCRIPT_URI']."?edit=".$name;
				$str .= "<item name=\"$name\" url=\"$url\" time=\"$time\" size=\"$size\"/>";
			}
		}
		closedir($dir);
	}
	$str .= $footer;
	return $str;
}
///////////////////////////////////////////////////////
 
?>
