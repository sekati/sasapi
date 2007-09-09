/**
 * com.sekati.except.IllegalArgumentException
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.except.Throwable;
 
/**
 * Illegal Argument Exception Error {@link Throwable}.
 */
class com.sekati.except.IllegalArgumentException extends Throwable {
	
	private var name:String = "Illegal Argument Error";
	private var type:String = "error";

	/**
	 * IllegalArgumentException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	 public function IllegalArgumentException(thrower:Object, message:String, stack:Array){
	 	super(thrower, message, stack);	
	 }
}