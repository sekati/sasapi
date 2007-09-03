/**
 * com.sekati.except.Exception
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.except.IThrowable;
 import com.sekati.reflect.Stringifier;
 
/**
 * Core Exception.
 */
class com.sekati.except.Exception extends Error implements IThrowable {
	
	/**
	 * Clean and destroy the object instance for garbage collector.
	 */	
	public function destroy():Void {		
	}

	/**
	 * Return reflective output.
	 * @return String
	 */	
	public function toString():String {
		return Stringifier.stringify(this);
	}	
	
}