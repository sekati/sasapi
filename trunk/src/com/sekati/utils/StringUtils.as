/**
 * com.sekati.utils.StringUtils
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 /**
  * static class wrapping various String utilities
  */
class com.sekati.utils.StringUtils {
	/**
	 * search for key in string
	 * @param str (String)
	 * @param key (String)
	 * @return Boolean
	 */
	public static function search (str:String, key:String):Boolean {
		return (str.indexOf (key) <= -1) ? false : true;
	}
	/**
	 * replace every instance of a string with something else
	 * @param str (String)
	 * @param oldChar (String)
	 * @param newChar (String)
	 * @return String
	 */
	public static function replace (str:String, oldChar:String, newChar:String):String {
		return str.split (oldChar).join (newChar);
	}
	/**
	 * remove spaces
	 * @param str (String)
	 * @return String
	 */
	public static function removeSpaces (str:String):String {
		return replace (str, " ", "");
	}
	/**
	 * remove spaces at end and beginning of the string only
	 * @param str (String)
	 * @return String
	 */
	public static function trim (str:String):String {
		var index0:Number = 0;
		while (str.charAt (index0) == " ") {
			index0++;
		}
		var index1:Number = str.length - 1;
		while (str.charAt (index1) == " ") {
			index1--;
		}
		return str.substring (index0, index1 + 1);
	}
	/**
	 * remove spaces  tabs, line feeds, carrige returns from string
	 * @param str (String)
	 * @return String
	 */
	public static function xtrim (str:String):String {
		var o:String = new String ();
		var TAB:Number = 9;
		var LINEFEED:Number = 10;
		var CARRIAGE:Number = 13;
		var SPACE:Number = 32;
		for (var i:Number = 0; i < str.length; i++) {
			if (str.charCodeAt (i) != SPACE && str.charCodeAt (i) != CARRIAGE && str.charCodeAt (i) != LINEFEED && str.charCodeAt (i) != TAB) {
				o += str.charAt (i);
			}
		}
		return o;
	}
	/**
	 * trim spaces and camel notate string
	 * @param str (String)
	 * @return String
	 */
	public static function trimCamel (str:String):String {
		var o:String = new String ();
		for (var i = 0; i < str.length; i++) {
			if (str.charAt (i) != " ") {
				if (justPassedSpace) {
					o += str.charAt (i).toUpperCase ();
					justPassedSpace = false;
				} else {
					o += str.charAt (i).toLowerCase ();
				}
			} else {
				var justPassedSpace = true;
			}
		}
		return o;
	}
	/**
	 * check if a string is blank after a safety trim
	 * @param str (String)
	 * @return Boolean
	 */
	public static function isBlank (s:String):Boolean {
		var str = trim (s);
		var i = 0;
		if (str.length == 0) {
			return true;
		}
		while (i < str.length) {
			if (str.charCodeAt (0) != 32) {
				return false;
			}
			i++;
		}
		return true;
	}
	/**
	 * check if string is valid email
	 * @param str (String)
	 * @return Boolean
	 */
	public static function isValidEmail (str):Boolean {
		return ((str.length < 6) || (str.indexOf ("@") < 1) || (str.length - (str.indexOf ("@")) < 5) || (str.indexOf ("@") != str.lastIndexOf ("@")) || (str.length - (str.lastIndexOf (".")) < 3) || (str.length - (str.lastIndexOf (".")) > 5) || (Math.abs ((str.indexOf ("@")) - (str.indexOf ("."))) == 1) || (str.indexOf (" ") != -1)) ? false : true;
	}
	/**
	 * add cacheKiller
	 * @param str (String)
	 * @return String
	 */
	public static function noCache (str:String):String {
		return str + "?" + new Date ().getTime ();
	}
	/**
	* encode html
	* @param str (String)
	* @return String
	*/
	public static function htmlEncode (str:String):String {
		var s:String = str, a = new String ();
		a = s.split ("&"), s = a.join ("&amp;");
		a = s.split (" "), s = a.join ("&nbsp;");
		a = s.split ("<"), s = a.join ("&lt;");
		a = s.split (">"), s = a.join ("&gt;");
		a = s.split ('"'), s = a.join ("&quot;");
		return s;
	}
	/**
	* strip html markup tags
	* @param str (String)
	* @return String
	*/
	public static function stripTags (str:String):String {
		var s:Array = new Array ();
		var c:Array = new Array ();
		for (var i = 0; i < str.length; i++) {
			if (str.charAt (i) == "<") {
				s.push (i);
			} else if (str.charAt (i) == ">") {
				c.push (i);
			}
		}
		var o:String = str.substring (0, s[0]);
		for (var j = 0; j < c.length; j++) {
			o += str.substring (c[j] + 1, s[j + 1]);
		}
		return o;
	}
	/**
	* detect html breaks
	* @param str (String)
	* @return Boolean
	*/
	public static function detectBr (str:String):Boolean {
		return (str.split ("<br").length > 1) ? true : false;
	}
	/**
	* convert single quotes to double quotes
	* @param str (String)
	* @return String
	*/
	public static function toDoubleQuote (str:String):String {
		var sq:String = "'";
		var dq:String = String.fromCharCode (34);
		return str.split (sq).join (dq);
	}
	/**
	* convert double quotes to single quotes
	* @param str (String)
	* @return String
	*/
	public static function toSingleQuote (str:String):String {
		var sq:String = "'";
		var dq:String = String.fromCharCode (34);
		return str.split (dq).join (sq);
	}
	//
}
// eof
