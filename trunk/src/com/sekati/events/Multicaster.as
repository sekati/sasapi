/**
 * com.sekati.events.Multicaster
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.CoreInterface;
 import com.sekati.core.KeyFactory;
 import com.sekati.reflect.Stringifier;
 import com.sekati.utils.Delegate;
 import com.sekati.validate.TypeValidation;
 
/**
 * The Multicaster Singleton is the middle-ground between
 * {@link Broadcaster} which broadcasts to all listeners for all events and
 * {@link Dispatcher} which dispatches {@link Event}s to listeners based on 
 * the events they have subscribed to.
 * 
 * In other words Multicaster is a Broadcaster with event-subscribed 
 * granularity not tied to the {@link Event} object or the mx.events.EventDispatcher
 * and is more optimized than {@link Broadcaster}. 
 */
class com.sekati.events.Multicaster implements CoreInterface {

	private static var _instance:Multicaster;
	private var _listeners:Array;

	/**
	 * Singleton Private Constructor
	 */
	private function Multicaster () {
		_listeners = new Array ();
	}
	
	/**
	 * Singleton Accessor
	 * @return Multicaster
	 */
	public static function getInstance ():Multicaster {
		if (!_instance) {
			_instance = new Multicaster ();
		}
		return _instance;
	}

	/**
	 * shorthand singleton accessor getter
	 * @return Multicaster
	 */
	 public static function get $():Multicaster {
	 	return Multicaster.getInstance();	
	 }	
	 
	/**
	 * Add a new multicast listener.
	 * @param o (Object) object to subscribe
	 * @param event (String) event name
	 * @param fn (Delegate) the delegated function to fire upon the event broadcast.
	 * @return Number
	 */
	public function addListener (o:Object, event:String, fn:Delegate):Number {
		var index:Object = getIndex(o);
		if( !_listeners[index] ) _listeners[index] = new Array();
		if( !_listeners[index][event] ) _listeners[index][event] = new Array();
		return _listeners[index][event].push(fn);
	}
	
	/**
	 * Remove a multicast listener.
	 * @param o (Object) object to unsubscribe
	 * @param event (String) event name
	 * @param fn (Delegate) the delegated function.
	 * @return Boolean
	 */
	public function removeListener (o:Object, event:String, fn:Delegate):Boolean {
		var index:Object = getIndex(o);
		var e:Array = _listeners[index][event];
		for(var i in e){
			if(e[i] === fn) delete _listeners[index][event][i];
			return true;
		}
		return false;
	}

	/**
	 * Subscribe a new multicast listener (addListener shortcut)
	 * @param o (Object) object to subscribe
	 * @param event (String) event name
	 * @param fn (Delegate) the delegated function to fire upon the event broadcast.
	 * @return Number
	 */	
	public function subscribe(o:Object, event:String, fn:Delegate):Void {
		addListener(o, event, fn);
	}

	/**
	 * Unsubscribe a multicast listener (removeListener shortcut).
	 * @param o (Object) object to unsubscribe
	 * @param event (String) event name
	 * @param fn (Delegate) the delegated function.
	 * @return Boolean
	 */	
	public function unsubscribe(o:Object, event:String, fn:Delegate):Void {
		removeListener(o, event, fn);
	}
	
	/**
	 * clear all listeners and reset the multicaster.
	 * @return Void
	 */
	public function reset ():Void{
		_listeners = new Array();
	}
	
	/**
	 * Broadcast to all listeners (can accept extra args)
	 */
	public function broadcast (o:Object, event:String):Void {
		broadcastArrayArgs (o, event, arguments.slice(2));
	}
	
	/**
	 * Broadcast to all listeners (can accept extra args as array)
	 */
	public function broadcastArrayArgs(o:Object, event:String, args:Array):Void{
		var index:Object = getIndex(o);
		var e:Array = _listeners[index][event];
		for(var i in e) e[i].getFunction().apply(this, args);
	}
		
	/**
	 * Gets index to use, and will inject key in object if needed
	 * This allows using objects or strings/numbers as channel for the broadcaster
	 * Will return either a number or a string
	 */
	private function getIndex(broadcasterObj:Object):Object{
		var o = broadcasterObj;
		
		if( TypeValidation.isString(o) || TypeValidation.isNumber(o) ){
			return String(o);
		}else if (TypeValidation.isObject(o) || TypeValidation.isMovieClip(o) || TypeValidation.isFunction(o) ){
			return KeyFactory.getKey(o);
		}else{
			//trace("Broadcaster error: Unsupported broadcaster type. Can be object, movieclip, function, string or number");
		}
	}
	
	/**
	 * Destroy singleton instance.
	 * @return Void
	 */
	public function destroy():Void {
		delete _listeners;
		delete _instance;
	}	
	
	/**
	 * Override with reflective output.
	 * @return String
	 */
	public function toString():String {
		return Stringifier.stringify(this);	
	}	
}