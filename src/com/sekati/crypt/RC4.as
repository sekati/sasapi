/**
 * com.sekati.crypt.RC4
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from ascrypt for dependencies only - version 1.0, author Mika Pamu
 * Orginal Flash port by: Gabor Penoff - http://www.fns.hu | fns@fns.hu
 */

import com.sekati.crypt.ICipher;

/**
 * Encrypts and decrypts an alleged RC4 hash.
 */
class com.sekati.crypt.RC4 implements ICipher {

	private static var sbox:Array = new Array( 255 );
	private static var mykey:Array = new Array( 255 );

	/**
	 * Encrypts a string with the specified key.
	 * @param src (String) string to encrypt
	 * @param key (String) encryption key
	 * @return String
	 */
	public static function encrypt(src:String, key:String):String {
		var mtxt:Array = strToChars( src );
		var mkey:Array = strToChars( key );
		var result:Array = calculate( mtxt, mkey );
		return charsToHex( result );
	}

	/**
	 * Decrypts a string with the specified key.
	 * @param src (String) string to decrypt
	 * @param key (String) decryption key
	 * @return String
	 */
	public static function decrypt(src:String, key:String):String {
		var mtxt:Array = hexToChars( src );
		var mkey:Array = strToChars( key );
		var result:Array = calculate( mtxt, mkey );
		return charsToStr( result );
	}

	private static function initialize(pwd:Array):Void {
		var b:Number = 0;
		var tempSwap:Number;
		var intLength:Number = pwd.length;
		var a:Number;
		for (a = 0; a <= 255 ; a++) {
			mykey[a] = pwd[(a % intLength)];
			sbox[a] = a;
		}
		for (a = 0; a <= 255 ; a++) {
			b = (b + sbox[a] + mykey[a]) % 256;
			tempSwap = sbox[a];
			sbox[a] = sbox[b];
			sbox[b] = tempSwap;
		}
	}

	private static function calculate(plaintxt:Array, psw:Array):Array {
		initialize( psw );
		var i:Number = 0; 
		var j:Number = 0;
		var cipher:Array = new Array( );
		var k:Number, temp:Number, cipherby:Number;
		for (var a:Number = 0; a < plaintxt.length ; a++) {
			i = (i + 1) % 256;
			j = (j + sbox[i]) % 256;
			temp = sbox[i];
			sbox[i] = sbox[j];
			sbox[j] = temp;
			var idx:Number = (sbox[i] + sbox[j]) % 256;
			k = sbox[idx];
			cipherby = plaintxt[a] ^ k;
			cipher.push( cipherby );
		}
		return cipher;
	}

	private static function charsToHex(chars:Array):String {
		var result:String = new String( "" );
		var hexes:Array = new Array( "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" );
		for (var i:Number = 0; i < chars.length ; i++) {
			result += hexes[chars[i] >> 4] + hexes[chars[i] & 0xf];
		}
		return result;
	}

	private static function hexToChars(hex:String):Array {
		var codes:Array = new Array( );
		for (var i:Number = (hex.substr( 0, 2 ) == "0x") ? 2 : 0; i < hex.length ; i += 2) {
			codes.push( parseInt( hex.substr( i, 2 ), 16 ) );
		}
		return codes;
	}

	private static function charsToStr(chars:Array):String {
		var result:String = new String( "" );
		for (var i:Number = 0; i < chars.length ; i++) {
			result += String.fromCharCode( chars[i] );
		}
		return result;
	}

	private static function strToChars(str:String):Array {
		var codes:Array = new Array( );
		for (var i:Number = 0; i < str.length ; i++) {
			codes.push( str.charCodeAt( i ) );
		}
		return codes;
	}

	private function RC4() {
	}
}