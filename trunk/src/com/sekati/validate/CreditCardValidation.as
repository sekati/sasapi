/**
 * com.sekati.validate.CreditCardValidation
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 import com.sekati.crypt.Luhn;
/**
 * Credit Card Validation class
 * TODO Add number string formatting to remove spaces, dashes, etc.
 */
class com.sekati.validate.CreditCardValidation {
	private static var DEFAULT_ENCODE_DIGITS_SHOWN:Number = 4;
	private static var DEFAULT_ENCODE_CHARACTER:String    = "*";
	private static var MINIMUM_CARD_LENGTH:Number         = 13;
	private static var MAXIMUM_CARD_LENGTH:Number         = 16;
	/**
	 * validate a credit card expiration date
	 * @param nMonth (Number)
	 * @param nYear (Number)
	 * @return Boolean
	 * {@code Usage:
	 * 	var isValidDate:Boolean = CreditCardValidation.isValidExDate(11,2010);
	 * }
	 */
	public static function isValidExDate (nMonth:Number, nYear:Number):Boolean {
		var objDate:Date = new Date();
		var nCurrentMonth:Number = objDate.getMonth() + 1;
		var nCurrentYear:Number  = objDate.getFullYear();
		if((nYear > nCurrentYear) || (nYear == nCurrentYear && nMonth >= nCurrentMonth)) {
			return true;
		}
		return false;
	}
	/**
	 * validate a credit card number as much as possible before submitting for approval
	 * @param strNumber (String) card number as string
	 * @return Boolean
	 * {@code var isValidNumber:Boolean = CreditCardValidation("1234567890123456"); }
	 */
	public static function isValidNumber (strNumber:String):Boolean {
		if(strNumber.length > 0 && !isNaN(strNumber) && (strNumber.length >= MINIMUM_CARD_LENGTH && strNumber.length <= MAXIMUM_CARD_LENGTH)) {
			return Luhn.mod10(strNumber);
		}
		return false;
	}
	/**
	 * Encode a credit card number as a string and encode all digits except the last nDigitsShown
	 * @param strNumber (String) credit card number as string
	 * @param nDigitsShown (Number) display this many digits at the end of the card number for security purposes
	 * @param strCharacter (String) optional encoding character to use instead of default '*'
	 * @return String
	 * {@code Usage:
	 * trace(CreditCardValidation.EncodeNumber("1234567890123456")); // ************3456
	 * trace(CreditCardValidation.EncodeNumber("1234567890123456", 5, "x"));  // xxxxxxxxxxx23456
	 * }
	 */
	public static function EncodeNumber(strNumber:String, nDigitsShown:Number, strCharacter:String):String {
		var strEncoded:String = "";
		nDigitsShown = (nDigitsShown != undefined && nDigitsShown != null) ? nDigitsShown : DEFAULT_ENCODE_DIGITS_SHOWN;
		strCharacter = (strCharacter != undefined && strCharacter != null) ? strCharacter : DEFAULT_ENCODE_CHARACTER;
		for(var i:Number=0; i < strNumber.length - nDigitsShown; i++) {
			strEncoded += strCharacter;
		}
		strEncoded += strNumber.slice(-nDigitsShown);
		return strEncoded;
	}
	//		
}
// eof