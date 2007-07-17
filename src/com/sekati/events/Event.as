/**
 * com.sekati.events.Event
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Base Event class, works similarly to the AS3 Event class
 */
class com.sekati.events.Event {
	private var _type:String;
	private var _target:Object;
	private var route:Array;
	
	public function Event(eventName:String, eventTarget:Object) {
		_type = eventName;
		_target = eventTarget;
		route = new Array();
	}
	public function get type():String {
		return _type;	
	}
	public function get target():Object {
		return _target;
	}
	public function bubble(newTarget:Object):Void {
		route.push(_target);
		_target = newTarget;
	}
	//
}
// eof