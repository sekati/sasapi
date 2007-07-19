/**
 * com.sekati.log.TraceObj
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 /**
  * recursively trace an objects contents
  * 
  * {@code Usage:
  * var a = ["a", "b", ["aa"], "BB", ["aaa", "BBB"], {joe:[833, 38]}];
  * TraceObj.recurse(a);
  * }
  */
class com.sekati.log.TraceObj {
	/**
	 * recursively trace object
	 * @param obj (Object) target object
	 * @param path (String)
	 * @param level (Number)
	 * @param maxPathLength (Number)
	 * @return Void
	 */
	public static function recurse (obj:Object, path:String, level:Number, maxPathLength:Number):Void {
		var padding:String;
		var paddingChar:String = " ";
		var parentType:String;
		var currentType:String;
		var newPath:String;
		//defaults
		if (level == null) {
			level = 0;
		}
		if (path == null) {
			path = "obj";
		}
		//maxPathLength (only defined initially)   
		if (maxPathLength == null) {
			maxPathLength = paddingRecursion (obj, path) + 3;
		}
		//calculate parents type   
		parentType = (obj instanceof Array) ? "array" : typeof (obj);
		for (var i in obj) {
			//calculate path
			newPath = (parentType == "array") ? path + "[" + i + "]" : path + "." + i;
			//calculate this type
			currentType = (obj[i] instanceof Array) ? "array" : typeof (obj[i]);
			//find how many padding I'll need for this item to print
			padding = "";
			for (var j = 0; j < maxPathLength - newPath.length; j++) {
				padding += paddingChar;
			}
			trace (newPath + padding + obj[i] + "  (" + currentType + ")");
			//go deeper
			recurse (obj[i], newPath, level + 1, maxPathLength);
		}
	}
	//recurse through everything to find what the biggest path string will be - strictly for formatting purposes
	private static function paddingRecursion (obj:Object, path:String, longestPath:Number):Number {
		var parentType:String;
		if (longestPath == null) {
			longestPath = 0;
		}
		//calculate parents type   
		parentType = (obj instanceof Array) ? "array" : typeof (obj);
		for (var i in obj) {
			//this levels path
			var newPath:String = (parentType == "array") ? path + "[" + i + "]" : path + "." + i;
			if (newPath.length > longestPath) {
				longestPath = newPath.length;
			}
			//outside recursion   
			var outsideRecursion:Number = paddingRecursion (obj[i], newPath, longestPath);
			if (outsideRecursion > longestPath) {
				longestPath = outsideRecursion;
			}
		}
		return longestPath;
	}
	
	private function TraceObj(){}
	//
}
// eof