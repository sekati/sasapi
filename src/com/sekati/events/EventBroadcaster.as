/**
 * com.sekati.events.EventBroadcaster
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.CoreObject;
 import com.sekati.core.KeyFactory;
 import com.sekati.except.Catcher;
 import com.sekati.except.IllegalOperationException;
 import com.sekati.utils.Delegate;
 import com.sekati.validate.TypeValidation;
 
/**
 * EventBroadcaster 
 */
class com.sekati.events.EventBroadcaster extends CoreObject {
	
	private static var _instance:EventBroadcaster;
	private var _listeners:Array;

	/**
	 * Singleton Private Constructor.
	 * @return Void
	 */
	private function EventBroadcaster() {
		super();
		_listeners = new Array();
	}

	/**
 	 * Singleton Accessor.
	 * @return EventBroadcaster
	 */
	public static function getInstance():EventBroadcaster {
		if (!_instance) _instance = new EventBroadcaster();
		return _instance;
	}
	
	/**
	 * Shorthand Singleton accessor getter.
	 * @return EventBroadcaster
	 */
	 public static function get $():EventBroadcaster {
	 	return EventBroadcaster.getInstance();	
	 }
	
	//=============================================================
	
	
	/**
	* Add a new listener
	*/
	public function addListener(broadcasterObj:Object, event:String, funk:Delegate):Void{
		var index:Object = getIndex(broadcasterObj);
		
		//push listener
		if( !_listeners[index] ) _listeners[index] = new Array();
		if( !_listeners[index][event] ) _listeners[index][event] = new Array();
		_listeners[index][event].push(funk);
	}
	
	
	/**
	* Remove a specific listener
	*/
	public function removeListener(broadcasterObj:Object, event:String, funk:Delegate):Void{
		var index:Object = getIndex(broadcasterObj);
		var e:Array = _listeners[index][event];
		for(var i in e){
			if(e[i] === funk) delete _listeners[index][event][i];
		}
	}
	
	
	/**
	* Remove all listeners
	*/
	public function removeAllListeners():Void{
		_listeners = new Array();
	}
	
	
	/**
	* Remove all listeners that are listening to a specific broadcaster
	*/
	public function removeAllFromBroadcaster(broadcasterObj:Object):Void{
		var index:Object = getIndex(broadcasterObj);
		delete _listeners[index];
	}
	
	
	/**
	* Remove all listeners that are listening to a specific broadcaster and a specific event
	*/
	public function removeAllFromBroadcasterAndEvent(broadcasterObj:Object, event:String):Void{
		var index:Object = getIndex(broadcasterObj);
		delete _listeners[index][event];
	}
	
	
	/**
	* Broadcast to all listeners (can accept extra args)
	*/
	public function broadcast(broadcasterObj:Object, event:String):Void{
		broadcastArrayArgs(broadcasterObj, event, arguments.slice(2));
	}
	
	
	/**
	 * Broadcast to all listeners (can accept extra args as array)
	 */
	public function broadcastArrayArgs(broadcasterObj:Object, event:String, args:Array):Void{
		var index:Object = getIndex(broadcasterObj);
		var e:Array = _listeners[index][event];
		for(var i in e) e[i].getFunction().apply(this, args);
	}
	
	/**
	 * Gets index to use, and will inject key in object if needed
	 * This allows using objects or strings/numbers as channel for the broadcaster
	 * Will return either a number or a string
	 * @param broadcasterObj (Object)
	 * @return Object
	 */
	private function getIndex (broadcasterObj:Object):Object {
		var o:Object = broadcasterObj;
		try {
			if (TypeValidation.isString(o) || TypeValidation.isNumber(o)) {
				return String(o);
			} else if (TypeValidation.isObject(o) || TypeValidation.isMovieClip(o) || TypeValidation.isFunction(o)) {
				return KeyFactory.getKey(o);
			} else {
				throw new IllegalOperationException(this, "Unsupported broadcaster type (must be object, clip, function, string or number).", arguments);
			}
		} catch (e:IllegalOperationException) {
			Catcher.handle(e);
		}
	}	
	
}