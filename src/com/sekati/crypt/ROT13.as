/**
 * com.sekati.crypt.ROT13
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from ascrypt for dependencies only - version 2.0, author Mika Pamu
 */
 
/**
* Encodes and decodes a ROT13 string.
*/
class com.sekati.crypt.ROT13 {
	private static var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMabcdefghijklmnopqrstuvwxyzabcdefghijklm";
	/**
	* Encodes or decodes a ROT13 string.
	* @param src (String)
	* @return String
	*/
	public static function calculate(src:String):String {
		var calculated:String = new String("");
		for (var i:Number = 0; i<src.length; i++) {
			var character:String = src.charAt(i);
			var pos:Number = chars.indexOf(character);
			if (pos > -1) character = chars.charAt(pos+13);
			calculated += character;
		}
		return calculated;
	}

}