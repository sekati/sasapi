/**
 * com.sekati.math.MathBase
 * @version 1.0.9
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.math.Integer;

 /**
  * static class wrapping various Math utilities
  */
class com.sekati.math.MathBase {			

	/**
	 * Returns the highest value of all passed arguments
	 * Like Math.max() but supports any number of args passed to it
	 */
	public static function max ():Number {
		return maxArray (arguments);
	}

	/**
	 * Returns the lowest value of all passed arguments
	 * Like Math.min() but supports any number of args passed to it
	 */
	public static function min ():Number {
		return minArray (arguments);
	}

	/**
	 * Returns the highest value of all items in array
	 * Like Math.max() but supports any number of items
	 */
	public static function maxArray (a:Array):Number {
		var val:Number = null;
		for (var i in a) {
			if (a[i] > val || val == null) {
				val = Number (a[i]);
			}
		}
		return val;
	}

	/**
	 * Returns the lowest value of all items in array
	 * Like Math.min() but supports any number of items
	 */
	public static function minArray (a:Array):Number {
		var val:Number = null;
		for (var i in a) {
			if (a[i] < val || val == null) {
				val = Number (a[i]);
			}
		}
		return val;
	}

	/**
	 * Same as Math.foor with extra argument to specify number of decimals
	 */
	public static function floor(val:Number, decimal:Number):Number {
		var n:Number = Math.pow(10,decimal);
		return Math.floor(val*n)/n;
	}	

	/**
	 * Round to a given amount of decimals
	 */
	public static function round (val:Number, decimal:Number):Number {
		return Math.round (val * Math.pow (10, decimal)) / Math.pow (10, decimal);
	}

	/**
	 * Round to nearest .5
	 * {@code Example:
	 * 	trace(MathBase.roundHalf(4.47)); // returns 4.5
	 * }
	 */	
	public static function roundHalf (val:Number):Number {
		var num:String = String (Math.round (val * 10) / 10);
		var tmp:Array = num.split (".");
		var integer:String = tmp[0];
		var decimal:Number = tmp[1];
		if (decimal >= 3 && decimal <= 7 && decimal != null) {
			decimal = 5;
		} else {
			if (decimal > 7) {
				integer = Number (integer) + 1;
			}
			decimal = 0;
		}
		return Number (integer + "." + decimal);
	}

	/**
	 * Will constrain a value to the defined boundaries
	 * {@code Examples:
	 * val: 20, 2 to 5    this will give back 5 since 5 is the top boundary
	 * val: 3, 2 to 5     this will give back 3
	 * }
	 */
	public static function constrain (val:Number, min:Number, max:Number):Number {
		if (val < min) {
			val = min;
		} else if (val > max) {
			val = max;
		}
		return val;
	}

	/**
	 * Check if number is Odd (convert to Integer if necessary)
	 */
	public static function isOdd (n:Number):Boolean {
		var int:Integer = new Integer(n);
		return Boolean(int%2);	
	}

	/**
	 * Check if number is Even (convert to Integer if necessary)
	 */
	public static function isEven (n:Number):Boolean {
		var int:Integer = new Integer(n);
		return (int%2 == 0);
	}

	/**
	 * Check if number is an Integer
	 */
	public static function isInteger (n:Number):Boolean {
		return (n%1 == 0);
	}

	/**
	 * Check if number is Natural (positive Integer)
	 */
	public static function isNatural(n:Number):Boolean {
		return (n >= 0 && n%1 == 0);
	}	

	////////////////////////////////////////////////////////////////////////////////////////////
	// RANDOMS
	/**
	 * Returns a random number inside a specific range
	 */	
	public static function rnd(start:Number, end:Number):Number {
		return Math.round( Math.random()*(end-start))+start;
	}

	/**
	 * Returns a set of random numbers inside a specific range (unique numbers is optional)
	 */
	public static function inRangeSet (min:Number, max:Number, count:Number, unique:Boolean):Array {
		var rnds:Array = new Array ();
		if (unique && count <= max - min + 1) {
			//unique
			// create num range array
			var nums:Array = new Array ();
			for (var i = min; i <= max; i++) {
				nums.push (i);
			}
			for (var i = 1; i <= count; i++) {
				// random number
				var rn = Math.floor (Math.random () * nums.length);
				rnds.push (nums[rn]);
				nums.splice (rn, 1);
			}
		} else {
			//non unique
			for (var i = 1; i <= count; i++) {
				rnds.push (randRangeInt (min, max));
			}
		}
		return rnds;
	}

	/**
	 * Returns a random float number within a given range
	 */
	public static function randRangeFloat (min:Number, max:Number):Number {
		return Math.random () * (max - min) + min;
	}

	/**
	 * Returns a random int number within a given range
	 */
	public static function randRangeInt (min:Number, max:Number):Number {
		return Math.floor (Math.random () * (max - min + 1) + min);
	}	
	
	private function MathBase(){
	}
}