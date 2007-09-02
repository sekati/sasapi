/**
 * com.sekati.core.CoreInterface
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * The core interface for each class in the SASAPI framework to follow.
 */
interface com.sekati.core.CoreInterface {
	
	/**
	 * Removes any internal variables, intervals, enterFrames, internal clips
	 * and event observers to allow the object to be garbage collected. 
	 * Always call destroy() before deleting last object pointer.
	 * @return Void
	 */		
	function destroy():Void;

	/**
	 * Returns the Fully Qualified Class Name as a string representation of the 
	 * instance via {@link com.sekati.reflect.Stringifier}.
	 * @return String
	 */		
	function toString():String;
	
}