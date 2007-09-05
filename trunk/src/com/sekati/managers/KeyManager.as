/**
 * com.sekati.managers.KeyManager
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 //import com.sekati.events.Dispatcher;
 import com.sekati.utils.Delegate;
 
/**
 * Key Manager Class.
 */
class com.sekati.managers.KeyManager {
	
	private static var _instance:KeyManager;
	private static var _this:KeyManager;
	private static var _key:Object;
	private static var _keyDownEVENT:String = "onKeyDown";
	private static var _keyUpEVENT:String = "onKeyUp";
	
	/**
	 * Singleton Private Constructor
	 */
	private function KeyManager () {
		_this = this;
		_key = new Object();
		_key.onKeyDown = Delegate.create(_this, onKeyDown);
		Key.addListener (_key);
	}
	
	private function onKeyDown():Void {
		//Dispatcher.$.dispatchEvent();	
		trace("KeyDown ::: ascii:" + Key.getAscii()+", keycode:"+Key.getCode());
		if ((Key.getCode() == Key.LEFT) && (Key.getCode() == Key.getCode.UP)) {
			trace("HOTKEY");
		}
	}
	
	private function onKeyUp():Void {
		trace("The ASCII code for the KeyUp is: " + Key.getAscii());	
	}
	
	public function hotKey(k:Array):Boolean {
		//if ((Key.isDown (Key.SHIFT) && Key.isDown (Key.RIGHT)) || (Key.isDown (Key.SHIFT) && Key.isDown (Key.LEFT)))
		return false;
	}
	
	/**
	 * Singleton Accessor
	 * @return KeyManager
	 */
	public static function getInstance ():KeyManager {
		if (!_instance) {
			_instance = new KeyManager ();
		}
		return _instance;
	}

	/**
	 * Shorthand singleton accessor getter
	 * @return KeyManager
	 */
	 public static function get $():KeyManager {
	 	return KeyManager.getInstance();	
	 }		
	
}