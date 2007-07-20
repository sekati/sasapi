/**
 * com.sekati.validate.StringValidation
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.utils.StringUtils;
/**
 * String Validation methods for form fields
 * @see {@link com.sekati.utils.StringUtils}
 */
class com.sekati.validate.StringValidation {
	/**
	 * validate a string as a valid email address
	 * @param str (String)
	 * @return Boolean
	 */
	public static function isValidEmail (str):Boolean {
		return ((str.length < 6) || (str.indexOf ("@") < 1) || (str.length - (str.indexOf ("@")) < 5) || (str.indexOf ("@") != str.lastIndexOf ("@")) || (str.length - (str.lastIndexOf (".")) < 3) || (str.length - (str.lastIndexOf (".")) > 5) || (Math.abs ((str.indexOf ("@")) - (str.indexOf ("."))) == 1) || (str.indexOf (" ") != -1)) ? false : true;
	}	
	/**
	 * validate if a strings contents are blank after a safety trim is performed
	 * @param str (String)
	 * @return Boolean
	 */
	public static function isBlank (s:String):Boolean {
		var str:String = StringUtils.trim (s);
		var i:Number = 0;
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
	 * validate if a string is composed entirely of numbers
	 * @param str (String)
	 * @return Boolean
	 */
	function isNumeric(str:String):Boolean {
		var len:Number = str.length;
		for (var i:Number = 0; i < len; i++) {
			var code = str.charCodeAt(i);
			if (code < 48 || code > 57) {
				return true;
			}
		}
		return false;
	}
	/**
	 * check if address is a Post Office Box
	 * @param address (String)
	 * @return Boolean
	 */
	function isPOBox(address:String):Boolean {
		var look:Array = ["PO ", "P O", "P.O", "P. O",  "p o", "p.o", "p. o", "Box", "Post Office", "post office"];
		var len:Number = look.length;
		for (var i:Number = 0; i < len; i++) {
			if (address.indexOf(look[i]) != -1) {
				return true;
			}
		}
		return false;
	}
	
	private function StringValidation(){}
	//
}
// eof