/**
 * com.sekati.math.MathBase
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
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
	 * Round to a given amount of decimals
	 */
	public static function round (val:Number, decimal:Number):Number {
		return Math.round (val * Math.pow (10, decimal)) / Math.pow (10, decimal);
	}
	/**
	 * Round to nearest .5
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
	 * val: 20, 2 to 5    this will give back 5 since 5 is the top boundary
	 * val: 3, 2 to 5      this will give back 3
	 * etc
	 */
	public static function constrain (val:Number, min:Number, max:Number):Number {
		if (val < min) {
			val = min;
		} else if (val > max) {
			val = max;
		}
		return val;
	}
	////////////////////////////////////////////////////////////////////////////////////////////
	// RANDOMS
	/**
	 * Returns a random number inside a specific range
	 */	
	public static function rnd( start:Number, end:Number ):Number {
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
	////////////////////////////////////////////////////////////////////////////////////////////
	// RULES	
	/**
	 * rule of 3's
	 */
	public static function ruleOf3 (partialValue:Number, totalValue:Number, partialPercent:Number, totalPercent:Number, zeroPercentValue:Number):Number {
		//defaults to 0% == 0
		if (zeroPercentValue == null) {
			zeroPercentValue = 0;
		}
		//calculate the null value    
		if (partialValue == null) {
			//partialValue
			return ((totalValue - zeroPercentValue) * partialPercent / totalPercent) + zeroPercentValue;
		} else if (totalValue == null) {
			//totalValue
			return ((partialValue - zeroPercentValue) * totalPercent / partialPercent) + zeroPercentValue;
		} else if (partialPercent == null) {
			//partialPercent
			return ((partialValue - zeroPercentValue) * totalPercent) / (totalValue - zeroPercentValue);
		} else if (totalPercent == null) {
			//totalPercent
			return ((totalValue - zeroPercentValue) * partialPercent) / (partialValue - zeroPercentValue);
		}
		//error    
		//return -1;
	}
	//
}
// eof
