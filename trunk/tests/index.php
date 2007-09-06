<?php
/*
 * Unit Test Runner - Created on Sep 2, 2007
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
///////////////////////////////////////////////////////
header('Content-type: text/html');
header('Cache-Control: no-cache, must-revalidate');
header('Pragma: no-cache');
header('Expires: -1');
error_reporting(E_ALL ^ E_NOTICE);

$appName = 'Sekati Unit Test Runner | jason m horwitz | sekati.com';

$header = '<!-- saved from url=(0013)about:internet -->';
$header .= '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />';
$header .= '<script language="javascript" src="../deploy/js/sasapi.js" type="text/javascript"></script>';
$header .= '<script language="javascript" src="../deploy/js/swfIN.js" type="text/javascript"></script>';
$header .= '<link rel="stylesheet" type="text/css" href="../deploy/css/style.css" />';
$header .= "<title>".$appName.'</title></head><body>';
$header .= '<a href="?" target="_self"><strong>Test Runner &raquo;</strong></a><hr/><br/>';

$footer = '<br/><hr/></body></html>';

$root = ".";
$path = reverse_strrchr($_SERVER['SCRIPT_FILENAME'],'/',0)."/".$root;
$self   = $_SERVER['SCRIPT_NAME'];
$swf	= $_GET['swf'];
$html	= $_GET['html'];

// (return everything up to last occurance of $needle + $trail num) | usage: $ns = reverse_strrchr($_SERVER["SCRIPT_URI"], "/", 1);
function reverse_strrchr($haystack, $needle, $trail) {
   return strrpos($haystack, $needle) ? substr($haystack, 0, strrpos($haystack, $needle) + $trail) : false;
}

function indexTests() {
	global $path;
	$str = "";
	if ($dir = @opendir($path)) {
		while (false !== ($item = readdir($dir))) {  
			if (eregi(".html", $item)) {
				$str .= "&bull; <a href=\"?html=$item\"><strong>$item</strong></a><br/>";
			} else if (eregi(".swf", $item)) {
				$str .= "&bull; <a href=\"?swf=$item\">$item</a><br/>";				
			}
		}
		closedir($dir);
	}
	return $str;
}

function template ($swf) {
	$str = '<div id="no_flash" style="display:none;"><h1>Flash Player Upgrade Required</h1><br /><a href="http://www.macromedia.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" target="_blank">&raquo; Download Flash plugin to view this site</a>&nbsp; &nbsp; &nbsp; &nbsp;<a href="javascript:location.reload(true)">&raquo; Enter Site</a></div>';
	$str .= '<script type="text/javascript">';
	$str .= 'var f = new swfIN("'.$swf.'", "unitTest", "950", "650");';
	$str .= 'f.minSize(950, 650);';
	$str .= 'f.useExpressInstall();';
	$str .= 'f.detect(8, "d", "no_flash");';
	$str .= 'f.addParam("bgcolor", "#292929");';
	$str .= 'f.addParam("menu", "true");';
	$str .= 'f.addParam("quality", "high");';
	$str .= 'f.addParam("scale", "noScale");';
	$str .= 'f.addParam("allowScriptAccess", "always");';
	$str .= 'f.addParam("swLiveConnect", "true");';
	$str .= 'f.addParam("allowFullScreen", "true");';
	$str .= 'f.write();';
	$str .= 'var mousewheel = new MouseWheel(f);';
	$str .= '</script>';
	return $str;
}
///////////////////////////////////////////////////////

if($swf) die($header.template($swf).$footer);
if($html) die ($header."Loading Test: $html ...<meta HTTP-EQUIV='Refresh' CONTENT='1;URL=$html'>.$footer");
echo ($header.indexTests().$footer);
?>
