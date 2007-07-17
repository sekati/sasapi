/**
 * com.sekati.core.RUID
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Runtime Unique ID generates unique Object ID's for management during application runtime
 */
class com.sekati.core.RUID {
	private static var _key:String = "__RUID";
	private static var _id:Number = 0;
	/**
	 * Generate a runtime unique id
	 * @return (Number) RUID
	 */
	public static function create():Number {
		return _id++;
	}
	/**
	 * return the RUID key injected into an object - used as both getter and setter.
	 * @param o (Object) Object to inject RUID key in to
	 * @return (Number) Runtime Unique ID
	 */
	public static function key(o:Object):Number {
		if (!o[_key]) {
			o[_key] = RUID.create();
			_global.ASSetPropFlags(o, [_key], 7, 1);
		}
		return o[_key];		
	}
	//
}
// eof