/**
 * com.sekati.core.CoreInterface
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * The basic interface for each class in the SASAPI framework.
 */
interface com.sekati.core.CoreInterface {
	
	/**
	 * Removes any internal variables, intervals, enterFrames, internal clips
	 * and event observers to allow the object to be garbage collected. 
	 * Always call destroy() before deleting last object pointer.
	 */		
	function destroy():Void;

	/**
	 * use default or override toString with more verbose trace output
	 */		
	function toString():String;
	
}