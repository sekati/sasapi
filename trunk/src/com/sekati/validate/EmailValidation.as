/**
 * com.sekati.validate.EmailValidation
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Email Address Validation class
 */
class com.sekati.validate.EmailValidation {
	/**
	 * validate a string as a valid email address
	 * @param str (String)
	 * @return Boolean
	 */
	public static function isValidEmail (str):Boolean {
		return ((str.length < 6) || (str.indexOf ("@") < 1) || (str.length - (str.indexOf ("@")) < 5) || (str.indexOf ("@") != str.lastIndexOf ("@")) || (str.length - (str.lastIndexOf (".")) < 3) || (str.length - (str.lastIndexOf (".")) > 5) || (Math.abs ((str.indexOf ("@")) - (str.indexOf ("."))) == 1) || (str.indexOf (" ") != -1)) ? false : true;
	}
	//
}
// eof