/**
 * com.sekati.display.ICoreClip
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Interface describing CoreClip which all MovieClip classes should be extended with instead of MovieClip
 */
interface com.sekati.display.ICoreClip {
	/**
	 * handles the MovieClip onLoad event which much call configUI
	 */
	function onLoad():Void;	
	/**
	 * class method called once the clip has loadeded and been registered
	 */
	function configUI():Void;
	/**
	 * override MovieClip toString with more verbose trace output
	 */
	function toString():String;
	//
}
// eof