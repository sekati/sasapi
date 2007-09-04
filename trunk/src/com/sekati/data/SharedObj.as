/**
 * com.sekati.data.SharedObj
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

 import com.sekati.core.CoreInterface;
 import com.sekati.events.Dispatcher;
 import com.sekati.events.Event;
 import com.sekati.reflect.Stringifier;
 import com.sekati.utils.Delegate;

/**
 * SharedObject extension
 */
class com.sekati.data.SharedObj extends SharedObject implements CoreInterface {
	
	private var _this:SharedObj;
	private var _so:SharedObject;
	private var _name:String;
	
	/**
	 * SharedObj Constructor
	 * @param so_name (String) shared object name
	 * @return Void
	 * @throws Error if no so_name was passed.
	 */
	public function SharedObj (so_name:String) {
		if(!so_name) {
			throw new Error ("@@@ "+this.toString()+" Error: instance constructor expects so_name param.");
			return;	
		}
		super();
		_name = so_name;
		_this = this;
		_so = SharedObj.getLocal(_name);
		_so.onStatus = Delegate.create(_this, so_onStatus);
		_so.onSync = Delegate.create(_this, so_onSync);
	}
	
	/**
	 * onStatus event handler dispatches event
	 */
	private function so_onStatus(info:Object):Void {
		trace ("status info: " + info);
		var e:Event = new Event("so_onStatus", this, {info:info});
		Dispatcher.$.dispatchEvent(e);
	}
	
	/**
	 * onSync event handler dispatches event
	 */
	private function so_onSync(obj:Object):Void {
		trace ("sync obj: " + obj);
		var e:Event = new Event("so_onSync", this, {obj:obj});
		Dispatcher.$.dispatchEvent(e);
	}
	
	/**
	 * write a property value to the shared object
	 * @param prop (String) property name
	 * @param val (Object) value to wrote to property
	 * @return Void
	 */
	public function write (prop:String, val:Object):Void {
		_so.data[prop] = val;
		_so.flush ();
	}
	
	/**
	 * read a property value from the shared object
	 * @param prop (String) property to read
	 * @return Object - property value
	 */
	public function read (prop:String):Object {
		return _so.data[prop];
	}
	
	/**
	 * destroy the shared object
	 */
	public function clear ():Void {
		_so.clear ();
	}
	
	/**
	 * get the size of the shared object
	 */
	public function getSize ():Void {
		_so.getSize ();
	}
	
	/**
	 * return recursively formatted data of shared object
	 */
	private function getData():String {
		var str:String = _name+"={\n";
		for (var prop in _so.data) {
			str += prop+": "+_so.data[prop]+"\n";
		}
		str += "\n};";
		return str;
	}
	
	/**
	 * Destroy sharedObject data and instance
	 * @return Void
	 */
	public function destroy():Void {
		_so.data = null;
		_so.flush();
		delete this;
	}	
		
	/**
	 * return reflective output
	 * @return String
	 */	
	public function toString():String {
		return Stringifier.stringify(this);
	}		
}