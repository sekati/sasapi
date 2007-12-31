/** * com.sekati.crypt.XOR * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ package com.sekati.crypt {	import com.sekati.crypt.ICipher;	/**	 * Encrypt and Decrypt a string with XORCRYPT Version 1.2 algorithm	 * @see http://www.eng.uwaterloo.ca/~ejones/software/xorcrypt12.js	 */	public class XOR implements ICipher {		/* Create the encrypt table 		The last char in the table is always the escape code		The table is not quite 128 chars, it is 95 (minus the escape char)		Values 93-127 must be escaped */		private static var cryptTable:String = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789	!@#$%^&*()`'-=[];,./?_+{}|:<>~";		//93 Chars		private static var cryptLength:Number = cryptTable.length - 1;		// The escape code is ~		//private var escapeChar:String = cryptTable.charAt(cryptLength);		//The linefeed char - escaped to double escapeChar		private static var lineFeed:String = "\n";		//Double quotes are escaped to ~'		private static var doubleQuote:String = '"';		// This function uses the key and encrypts a string with the password		// Encryption strips all linefeeds - but they are replaced upon decrypt			/**		 * Encrypts a string with the specified key.		 * @param input (String) string to encrypt		 * @param password (String) encryption key		 * @return String 		 * @example var enc:String = XOR.encrypt ("hello world","tooManySecrets");		 */	 		public static function encrypt(input:String, password:String):String {			var escapeChar:String = cryptTable.charAt( cryptLength );			var inChar:String, inValue:Object, outValue:Object;			var output:String = "";			var arNumberPw:Array = new Array( );			var pwLength:Number = password.length;			var inLength:Number = input.length;			var pwIndex:Number;			//			for (pwIndex = 0; pwIndex < pwLength ; pwIndex++) {				arNumberPw[pwIndex] = cryptTable.indexOf( password.charAt( pwIndex ) );			}			/* XOR all the chars */			pwIndex = 0;			for (var inIndex:Number = 0; inIndex < inLength ; inIndex++, pwIndex++) {				//Make sure the password index is in range					if (pwIndex == pwLength) {					pwIndex = 0;				}				/* Get the input */				inChar = input.charAt( inIndex );				inValue = cryptTable.indexOf( inChar );				/* Conversion/Escaping Sequence */				// If the outValue is in the character map, encode it				// If the encoded value is outside the character map, escape it				// Else convert it to a char				// If the input char is a linefeed, escape it				// If the input char is a double quote, escape it				// If the input char wasn't found, pass it through				if (inValue != -1) {					outValue = arNumberPw[pwIndex] ^ inValue;					if (outValue >= cryptLength) {						outValue = escapeChar + cryptTable.charAt( Number( outValue ) - cryptLength );					} else {						outValue = cryptTable.charAt( Number( outValue ) );					}				} else if (inChar == "\r") {					outValue = escapeChar + escapeChar;					//If it is a 2 char linefeed skip next one					if (input.charAt( inIndex + 1 ) == "\n") {						inIndex++;					}				} else if (inChar == "\n") {					outValue = escapeChar + escapeChar;				} else if (inChar == doubleQuote) {					outValue = escapeChar + "'";				} else {					outValue = inChar;				}				output += String( outValue );			}			return output;		}		/**		 * Decrypts a string with the specified key.		 * @param input (String) string to decrypt		 * @param password (String) decryption key		 * @return String		 * @example var dec:String = XOR.decrypt (enc,"tooManySecrets");		 */		public static function decrypt(input:String, password:String):String {			var inChar:String, inValue:Object, outValue:Object, escape:Boolean = false;			var output:String = "";			var arNumberPw:Array = new Array( );			var pwLength:Number = password.length;			var inLength:Number = input.length;			var pwIndex:Number;			for (pwIndex = 0; pwIndex < pwLength ; pwIndex++) {				arNumberPw[pwIndex] = cryptTable.indexOf( password.charAt( pwIndex ) );			}			/* XOR all the chars */			pwIndex = 0;			for (var inIndex:Number = 0; inIndex < inLength ; inIndex++, pwIndex++) {				if (pwIndex >= pwLength) {					//Make sure the password index is in range					pwIndex = 0;				}				/* Get the input */				inChar = input.charAt( inIndex );				inValue = cryptTable.indexOf( inChar );				/* Decrypting/Unescaping Sequence */				// If the input char wasn't found, pass it through (error checking)				// If the last char was an escapeChar				//And the input is an escapeChar, output a linefeed				//Or the input is a single quote, output a double quote				//Otherwise just add the cryptLength to the inValue				//Turn escape off				// If the inValue hasn't been coverted to an outValue yet				// If the inChar is an escapeChar, turn escape on				// Otherwise decrypt the encrypted character				if (inValue == -1) {					outValue = inChar;				} else if (escape) {					if (inValue == cryptLength) {						outValue = lineFeed;						inValue = -1;					} else if (inChar == "'") {						outValue = doubleQuote;						inValue = -1;					} else {						inValue += cryptLength;					}					escape = false;				} else if (inValue == cryptLength) {					escape = true;					pwIndex--;					//Stop the password from incrementing					outValue = "";					inValue = -1;				}				if (inValue != -1) {					outValue = cryptTable.charAt( arNumberPw[pwIndex] ^ inValue );				}				/* Output */				output += String( outValue );			}			return output;		}	}}