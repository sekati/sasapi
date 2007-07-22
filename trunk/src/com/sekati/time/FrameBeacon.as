/**
 * com.sekati.time.FrameBeacon
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.FWDepth;
import com.sekati.utils.ClassUtils;
import com.sekati.utils.Delegate;
 
/**
 * 
 */
class com.sekati.time.FrameBeacon {
	
	// AsBroadcaster stubs
	private var addListener:Function;
	private var removeListener:Function;
	private var broadcastMessage:Function;
	private var _listeners:Array;
		
	private static var _instance:FrameBeacon;
	private var _mc:MovieClip;
	private var _f:Function;
	
	public static var onEnterFrameEVENT:String = "_onEnterFrame";
	
	/**
	 * Singleton Private Constructor: initializes centralized management of mx.events.EventDispatcher
	 */
	private function FrameBeacon() {
		AsBroadcaster.initialize(this);
		_mc = ClassUtils.createEmptyMovieClip(com.sekati.display.BaseClip, _level0, "___FrameBeacon", {_depth:FWDepth.FrameBeacon});
		_f = Delegate.create(this, broadcastMessage, onEnterFrameEVENT);
	}

	/**
 	 * Singleton Accessor
	 * @return Dispatcher
	 */
	public static function getInstance():FrameBeacon {
		if (!_instance) {
			_instance = new FrameBeacon();
		}
		return _instance;
	}
	
	/**
	 * shorthand singleton accessor getter
	 */
	 public static function get $():FrameBeacon {
	 	return FrameBeacon.getInstance();	
	 }
	
	public function start():Void {
		_mc.onEnterFrame = _f;		
	}	
	
	public function stop():Void {
		_mc.onEnterFrame = null;
	}
	
	public function isRunning():Boolean{
		return _mc.onEnterFrame == _f;
	}	

	public function destroy():Void {
		_instance.stop();
		_mc.destroy();
		delete _instance;
	}
	
	public function addFrameListener(o:Object):Void{
		if (_listeners.length < 1) start();
		addListener(o);
	}
	
	public function removeFrameListener(o:Object):Void{
		removeListener(o);
		if (_listeners.length < 1) stop();
	}

	public function isListenerRegistered(o:Object):Boolean{
		for (var i in _listeners) if(_listeners[i] === o) return true;
		return false;
	}
	
}