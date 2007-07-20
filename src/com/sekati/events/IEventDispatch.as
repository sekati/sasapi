/**
 * com.sekati.events.IEventDispatch
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Interface describing {@link com.sekati.events.EventDispatch}, its sub/super classes
 */
interface com.sekati.events.IEventDispatch {
	function addEventListener (event:String, listener:Object):Void;
	function removeEventListener (event:String, listener:Object):Void;
	function dispatchEvent (eventObj:Object):Void;
	//
}
// eof