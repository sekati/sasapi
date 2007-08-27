/**
 * com.sekati.log.Logger
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreInterface; 
import com.sekati.events.Dispatcher;
import com.sekati.events.Event;
import com.sekati.log.Inspector;
import com.sekati.time.StopWatch;
 
/**
 * Logger is a multi-tiered debugging tool designed to clarify the debugging process.
 * 
 * The Logger consists of two main tiered components:
 * 	- "levels" (method calls, i.e. 'trace', 'info', 'status', etc).
 * 	- "filters" (origin of the level call, i.e. '_root', 'myClassInstance', 'myMc', etc).
 * 	
 * New level (methods) may be created dynamically "overloading" the singleton class 
 * via {@link setLevel}, __resolve & proxy as illustrated in the example usage below.
 * 
 * Logger can be configured to display its output in several different ways:
 * 	- Flash IDE Output Panel.
 * 	- {@link Console} hidden inside compiled swf.
 * 	- {@link Console} via {@link http://debug.sekati.com} localConnection.
 * 
 * @see {@link com.sekati.log.Console}
 */
class com.sekati.log.Logger implements CoreInterface {

	private static var _instance:Logger;

	private var _levels:Object;
	private var _filters:Array;
	private var _proxyObj;
	private var _watch:StopWatch;	
	private var _isEnabled:Boolean;
	private var _logId:Number;
	
	// default level stubs
	public var trace:Function;
	public var info:Function;
	public var status:Function;
	public var warn:Function;
	public var error:Function;
	public var fatal:Function;

	/**
	 * Singleton Private Constructor
	 */
	private function Logger() {
		resetLevels();
		resetFilters();
		_proxyObj = new Object();
		_watch = new StopWatch(true);
		_isEnabled = true;
		_logId = 0;
	}

	/**
	 * Singleton Accessor
	 * @return Logger
	 */	
	public static function getInstance ():Logger {
		if (!_instance) {
			_instance = new Logger();
		}
		return _instance;
	}

	/**
	 * Shorthand singleton accessor getter
	 * @return Logger
	 */
	 public static function get $():Logger {
	 	return Logger.getInstance();	
	 }
	 
	//////////////////////////////////////////////////////////////
	// Core Controllers
	
	/**
	 * enabled setter
	 * @param b (Boolean) enable or disable Logger
	 */
	public function set enabled (b:Boolean):Void {
		_isEnabled = b;
	}

	/**
	 * enabled getter
	 * @return Boolean
	 */	
	public function get enabled ():Boolean {
		return _isEnabled;
	}

	/**
	 * level and filter _status getter
	 * @return String
	 */
	public function get _status ():String {
		return getLevels () + "\n" + getFilters ();
	}

	/**
	 * reset Out to default levels and filters
	 * @return Void
	 */
	public function reset ():Void {
		setAllLevels (true);
		resetFilters ();
	}
	
	//////////////////////////////////////////////////////////////
	// Level Handlers

	/**
	 * Enable/disable a level and create the level if it does not already exist.
	 * @param level (String) level name
	 * @param isEnabled (Boolean) enabled status
	 * @return Void
	 */
	public function setLevel (level:String, isEnabled:Boolean):Void {
		_levels[level.toLowerCase()] = isEnabled;
	}

	/**
	 * Enable or disable all existing levels.
	 * @param isEnabled (Boolean) enabled status
	 * @return Void
	 */
	public function setAllLevels (isEnabled:Boolean):Void {
		for (var i in _levels) {
			setLevel (_levels[i],isEnabled);
		}
	}

	/**
	 * Reset all levels (clearing previously created levels)
	 * @return Void
	 */
	public function resetLevels():Void {
		_levels = {trace:true, info:true, status:true, warn:true, error:true, fatal:true, object:true};
	}

	/**
	 * Returns a stringified overview of all levels statuses.
	 * @return String
	 */
	public function getLevels ():String {
		var a:Array = new Array ();
		for (var i in _levels) {
			a.push (i + ":" + _levels[i].toString ());
		}
		return "_levels={" + a.toString () + "};";
	}
	
	//////////////////////////////////////////////////////////////
	// Filter Handlers
	
	/**
	 * Enable/disable a filter and create the filter if it does not already exist.
	 * @param origin (Object) object to filter on [usually a string]
	 * @param isFiltered (Boolean)
	 * @return Void
	 */
	public function setFilter (origin:Object, isFiltered:Boolean):Void {
		if (isFiltered) {
			filter(origin);
		} else {
			unfilter(origin);
		}
	}

	/**
	 * Returns a stringified overview of all filters statuses.
	 * @return String
	 */
	public function getFilters ():String {
		return "_filters=[" + _filters.toString () + "];";
	}

	/**
	 * Reset all filters (clearing previous filters)
	 * @return Void
	 */
	public function resetFilters ():Void {
		_filters = [];
	}
	
	/**
	 * Check if an origin's output is being filtered
	 * @param origin (Object) to check.
	 * @return Boolean
	 */
	public function isFiltered (origin:Object):Boolean {
		var o:String = String (origin);
		for (var i:Number = 0; i < _filters.length; i++) {
			if (_filters[i] == o) {
				return true;
			}
		}
		return false;
	}	
	
	/**
	 * Add an origin to the filters array.
	 * @param origin (Object) to be added.
	 * @return Void
	 */
	private function filter (origin:Object):Void {
		var o:String = String (origin);
		if (!isFiltered (o)) {
			_filters.push (o);
		}
	}

	/**
	 * Remove an origin from the filters array.
	 * @param origin (Object) to be removed.
	 * @return Void
	 */
	private function unfilter (origin:Object):Void {
		var o:String = String (origin);
		for (var i:Number = 0; i < _filters.length; i++) {
			if (_filters[i] == o) {
				_filters.splice (i,1);
				break;
			}
		}
	}

	/**
	 * Currently unused; AS3 has getNameSpace - when Logger is ported origin will change from string/mc to class  namespace.
	 * For now it may be better to keep filtering on object/string rather than class(?)
	 * @param origin (Object)
	 * @return Void
	 */
	private function resolveOrigin (origin):Void {
		var o = (typeof (origin) == "string") ? origin : origin._classname;
		if (!o) {
			o = origin;
		}
		trace (o);
	}	
	 
	//////////////////////////////////////////////////////////////
	// Output Handlers
	
	private function _output (level:String, origin, msg):Void {
		if (_isEnabled == false || _levels[level] == false || isFiltered (origin) == true) {
			return;
		}		
		var benchmark:Number = _watch.lap();
		var id:Number = _logId++;
		var e:Event = new Event("LOG_EVENT",this,{id:id, type:level.toLowerCase(), origin:String(origin), message:String(msg), benchmark:benchmark});
		Dispatcher.$.dispatchEvent(e);
		/*
		var o:String = level + ":[" + String (origin) + "]: " + msg;
		 if(!_isPanel) {
			trace(o);
		} else {
			var e:Event = new Event("OUT_EVENT",this,{message:o, level:level});
			Dispatcher.$.dispatchEvent(e);
		}
		 */
	}

	
	//////////////////////////////////////////////////////////////
	// Level Overloading	

	// __resolve catches all wrapper & invented levels and processes them thru the proxy to _output: cool!
	private function __resolve (name:String):Function {
		if (name.indexOf ("LOG_EVENT") > 1) {
			return;
		}
		var f:Function = function() {
			arguments.unshift (name);
			return __proxy.apply (_proxyObj, arguments);
		};
		_proxyObj[name] = f;
		return f;
	}

	private function __proxy (name:String) {
		arguments.shift ();
		var n:String = String (name).toUpperCase ();
		var o:String = String (arguments[0]);
		var s:String = String (arguments[1]);
		_instance._output (n,o,s);
	}
	
	//////////////////////////////////////////////////////////////
	// Special Level Method(s)
	
	/**
	 * object is a special level (method) which handles object recursion via {@link com.sekati.log.Inspector}
	 * @param origin (Object) origin for filtering purposes
	 * @param obj (Object) object to be recursed thru Out
	 * @return Void 
	 */
	public function object (origin:Object, obj:Object):Void {
		var insp:Inspector = new Inspector(obj,origin);
		_output ("OBJECT", origin, insp);
	}
	
	//////////////////////////////////////////////////////////////
	// Destroy Handler
	
	/**
	 * Destroy the Singleton instance.
	 */
	public function destroy():Void {
		
	}
}