/**
 * com.sekati.utils.ArrayUtils
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 /**
  * static class wrapping various Array utilities
  */
class com.sekati.utils.ArrayUtils {
	/**
	 * shuffle array items
	 * @param a (Array)
	 * @return Void
	 */
	public static function shuffle (a:Array):Void {
		for (var i:Number = 0; i < a.length; i++) {
			var tmp:Object = a[i];
			var randomNum:Number = random (a.length);
			a[i] = a[randomNum];
			a[randomNum] = tmp;
		}
	}
	/**
	 * return alphabetically sorted array
	 * @param a (Array)
	 * @return Array
	 */
	public static function asort (a:Array):Array {
		var aFn = function (element1:String, element2:String) {
			var element1:String = element1.toUpperCase ();
			var element2:String = element2.toUpperCase ();
			return element1 > element2;
		};
		return a.sort (aFn);
	}
	/**
	 * return array with duplicate entries removed
	 * @param a (Array)
	 * @return Array
	 */
	public static function removeDuplicate (a:Array):Array {
		a.sort ();
		var o:Array = new Array ();
		for (var i:Number = 0; i < a.length; i++) {
			if (a[i] != a[i + 1]) {
				o.push (a[i]);
			}
		}
		return o;
	}
	/**
	 * compare two arrays for a matching value
	 * @param a1 (Array)
	 * @param a2 (Array)	
	 * @return Boolean
	 */	
	public static function matchValues (a1:Array, a2:Array):Boolean {
		for (var f:Number = 0; f < a1.length; f++) {
			for (var l:Number = 0; l < a2.length; l++) {
				if (a2[l].toLowerCase () === a1[f].toLowerCase ()) {
					return true;
				}
			}
		}
		return false;
	}
}
// eof
