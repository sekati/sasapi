/**
 * com.sekati.events.IMulticastable
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.CoreInterface;
 import com.sekati.utils.Delegate;
 
/**
 * Interface describing Event Multicasters such as {@link com.sekati.events.Multicaster}.
 */
interface com.sekati.events.IMulticastable extends CoreInterface {

	function subscribe(o:Object, event:String, fn:Delegate):Void;

	function unsubscribe(o:Object, event:String, fn:Delegate):Void;

	function reset():Void;

	function broadcast(o:Object, event:String):Void;

	function addListener(o:Object, event:String, fn:Delegate):Number;

	function removeListener(o:Object, event:String, fn:Delegate):Boolean;
	
}