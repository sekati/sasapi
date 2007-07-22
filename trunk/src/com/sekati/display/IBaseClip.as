/**
 * com.sekati.display.IBaseClip
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Interface describing {@link com.sekati.display.BaseClip} which is 
 * the foundational building block class for all subclasses to 
 * extend instead of MovieClip.
 */
interface com.sekati.display.IBaseClip {

	/**
	 * Removes any internal variables, intervals, enterFrames, internal clips
	 * and event observers to allow the object to be garbage collected. 
	 * Always call destroy() before deleting last object pointer.
	 */	
	function destroy():Void;
	
	/**
	 * if destroy is not called manually onUnload will fire destroy.
	 */
	function onUnload():Void;
	
	/**
	 * use default or override toString with more verbose trace output
	 */	
	function toString():String;
	
}