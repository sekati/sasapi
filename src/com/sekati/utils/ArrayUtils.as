/**
 * com.sekati.utils.ArrayUtils
 * @version 1.1.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 /**
  * static class wrapping various Array utilities
  */
class com.sekati.utils.ArrayUtils {
	/**
	 * insert an element into array at a specific index
	 * @param a (Array)
	 * @param objElement (Object)
	 * @param nIndex (Number)
	 * @return Array
	 */
	public static function insert (a:Array, objElement:Object, nIndex:Number):Array {
		var aA:Array = a.slice(0, nIndex - 1);
		var aB:Array = a.slice(nIndex, a.length - 1);
		aA.push (objElement);
		return ArrayUtils.merge(aA, aB);
	}
	/**
	 * remove all instances of an element from an array
	 * @param a (Array)
	 * @param objElement (Object)
	 * @return Array
	 */
	public static function remove (a:Array, objElement:Object):Array {
		for(var i:Number = 0; i < a.length; i++) {
			if (a[i] === objElement) {
				a.splice(i, 1);
			}
		}
		return a;
	}
	/**
	 * search an array for a given element and return its index or null
	 * @param a (Array)
	 * @param objElement (Object)
	 * @return Number
	 */	
	public static function search (a:Array, objElement:Object):Number {
		for (var i:Number = 0; i < a.length; i++) {
			if (a[i] === objElement) {
				return i;
			}
		}
 		return null;
	}
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
	 * return a clone of the array
	 * @param a (Array)
	 * @return Array
	 */
	public static function clone (a:Array):Array {
		return a.concat();
	}
	/**
	 * merge two arrays into one
	 * @param aA (Array)
	 * @param aB (Array)
	 * @return Array
	 */
	public static function merge (aA:Array, aB:Array):Array {
		var aC:Array = ArrayUtils.clone(aB);
		for(var i:Number = aA.length - 1; i > -1; i--) {
			aC.unshift(aA[i]);
		}
		return aC;
	}	
	// Swaps two elements at the given indexes of the subject array.
	/**
	 * Swap two elements positions in an array
	 * @param a (Array)
	 * @param nA (Number) element A's index
	 * @param nB (Number) element B's index
	 * @return Array
	 */
	public static function swap (a:Array, nA:Number, nB:Number):Array {
		if (nA >= a.length || nA < 0) {
			throw new Error ("@@@ com.sekati.utils.ArrayUtils.swap() Error: Index 'A' (" + nA + ") is not a valid index in the array '" + a.toString() + "'.");
			return a;
		}
		if(nB >= a.length || nB < 0) {
			throw new Error ("@@@ com.sekati.utils.ArrayUtils.swap() Error: Index 'A' (" + nB + ") is not a valid index in the array '" + a.toString() + "'.");
			return a;
		}
		var objElement:Object = a[nA];
		a[nA] = a[nB];
		a[nB] = objElement;
		return a;
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
	 * @param aA (Array)
	 * @param aB (Array)	
	 * @return Boolean
	 */	
	public static function matchValues (aA:Array, aB:Array):Boolean {
		for (var f:Number = 0; f < aA.length; f++) {
			for (var l:Number = 0; l < aB.length; l++) {
				if (aB[l].toLowerCase () === aA[f].toLowerCase ()) {
					return true;
				}
			}
		}
		return false;
	}
	/**
	 * compare two arrays to see if they are identical
	 * @param aA (Array)
	 * @param aB (Array)
	 * @return Boolean
	 */
	public static function compare(aA:Array, aB:Array):Boolean {
		if(aA.length != aB.length) {
			return false;
		}
		for(var i:Number = 0; i < aA.length; i++) {
			if(aA[i] !== aB[i]) {
				return false;
			}
		}
		return true;
	}
	//
}
// eof
