﻿/** * com.sekati.log.Out * @version 1.7.7 * @author jason m horwitz | sekati.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ import com.sekati.log.OutPanel;import com.sekati.log.Inspector;import com.sekati.events.Dispatcher;import com.sekati.events.Event;/** * Out is a multi-tiered trace replacement which uses debug levels and * object/instance filters to assist and clarify the debugging process. * New level method calls can be created dynamically "overloading"  * the class via __resolve and proxy. *  * TODO Add localConnection for remote OutPanel option. *  * {@code Usage: * var out:Out = Out.getInstance(); * out.createPanel(640,480); // optionally create an outPanel in the swf * out.trace(this,"hello world"); // simple hello world * out.setFilter(this,true); // filters this object from further output * out.info(this,"hello world"); // wont display due to filter * out.setFilter(this,false); // unfilter this object * out.setLevel("trace",false); // disable level trace * out.trace(this,"hello world"); // wont display due to disabled level * out.setLevel("debug",true); // creates a new level named "debug" & enable it * out.debug(this,"hello world"); // displays within the new debug level * out.object(this,{foo:5, bar:1}); // special object level does basic object recursion * } */class com.sekati.log.Out {	private static var _instance:Out;	private static var _levels:Object = {TRACE:true, INFO:true, STATUS:true, WARN:true, ERROR:true, FATAL:true, OBJECT:true};	private static var _filters:Array = new Array();	private static var _proxyObj = new Object();	private static var _isEnabled:Boolean = true;	private static var _isPanel:Boolean = false;	// default level stubs	public var trace:Function;	public var info:Function;	public var status:Function;	public var warn:Function;	public var error:Function;	public var fatal:Function;	/**	 * Singleton Private Constructor	 */	private function Out() {	}	/**	 * Singleton Accessor	 * @return Out	 */		public static function getInstance ():Out {		if (!_instance) {			_instance = new Out ();		}		return _instance;	}	/**	 * shorthand singleton accessor getter	 */	 public static function get $():Out {	 	return Out.getInstance();		 }		/**	 * wrapper to draw a panel to swf for output via {@link OutPanel}	 * @param w (Number) panel width	 * @param h (Number) panel height	 * @return Void	 */	public function createPanel (w:Number, h:Number):Void {		_isPanel = true;		OutPanel.getInstance (w,h);	}	// Core controllers	/**	 * Out enabled setter	 * @param b (Boolean) enable or disable Out	 */	public function set enabled (b:Boolean):Void {		_isEnabled = b;	}	/**	 * Out enabled getter	 * @return Boolean	 */		public function get enabled ():Boolean {		return _isEnabled;	}	/**	 * level and filter _status getter	 * @return String	 */	public function get _status ():String {		return getLevels () + "\n" + getFilters ();	}	/**	 * reset Out to default levels and filters	 * @return Void	 */	public function reset ():Void {		setAllLevels (true);		resetFilters ();	}	// Level Handlers	/**	 * set a levels enabled status or create a new level	 * @param level (String) level name	 * @param isEnabled (Boolean)	 * @return Void	 */	public function setLevel (level:String, isEnabled:Boolean):Void {		_levels[level.toUpperCase ()] = isEnabled;	}	/**	 * set all levels status	 * @param isEnabled (Boolean)	 * @return Void	 */	public function setAllLevels (isEnabled:Boolean):Void {		for (var i in _levels) {			setLevel (_levels[i],isEnabled);		}	}	/**	 * returns a string of all levels for overview/status purposes	 * @return String	 */	public function getLevels ():String {		var a:Array = new Array ();		for (var i in _levels) {			a.push (i + ":" + _levels[i].toString ());		}		return "_levels={" + a.toString () + "};";	}	// Object Filters	/**	 * set a filters enabled status or create a new filter	 * @param origin (Object) object to set filter on	 * @param isFiltered (Boolean)	 * @return Void	 */	public function setFilter (origin:Object, isFiltered:Boolean):Void {		if(isFiltered) {			filter(origin);		} else {			unfilter(origin);		}	}	/**	 * return a string of all filters for overview/status purposes	 * @return String	 */	public function getFilters ():String {		return "_filters=[" + _filters.toString () + "];";	}	/**	 * reset all filters	 */	public function resetFilters ():Void {		_filters = [];	}	private function filter (origin:Object):Void {		var o:String = String (origin);		if (!isFiltered (o)) {			_filters.push (o);		}	}	private function unfilter (origin:Object):Void {		var o:String = String (origin);		for (var i:Number = 0; i < _filters.length; i++) {			if (_filters[i] == o) {				_filters.splice (i,1);				break;			}		}	}	public function isFiltered (origin:Object):Boolean {		var o:String = String (origin);		for (var i:Number = 0; i < _filters.length; i++) {			if (_filters[i] == o) {				return true;			}		}		return false;	}	// currently unused - as3 has getNameSpace - for now maybe better to keep filtering on object/string rather than class?	private function resolveOrigin ($origin) {		var o = (typeof ($origin) == "string") ? $origin : $origin._classname;		if (!o) {			o = $origin;		}		trace (o);	}	// Output methods	private function _output (level:String, origin, msg):Void {		if (!_isEnabled || !_levels[level] || isFiltered (origin)) {			return;		}		var o:String = level + ":[" + String (origin) + "]: " + msg;		if(!_isPanel) {			trace(o);		} else {			var e:Event = new Event("OUT_EVENT",this,{message:o, level:level});			Dispatcher.$.dispatchEvent(e);		}	}	// __resolve catches all wrapper & invented levels and processes them thru the proxy to _output: cool!	private function __resolve (name:String):Function {		if (name.indexOf ("OUT_EVENT") > 1) {			return;		}		var f:Function = function () {		arguments.unshift (name);		return __proxy.apply (_proxyObj, arguments);		};		_proxyObj[name] = f;		return f;	}	private function __proxy (name:String) {		arguments.shift ();		var n:String = String (name).toUpperCase ();		var o:String = String (arguments[0]);		var s:String = String (arguments[1]);		_instance._output (n,o,s);	}	/**	 * object is a special level that does object 	 * recursion via {@link com.sekati.log.Inspector}	 * @param origin (Object) origin for filtering purposes	 * @param obj (Object) object to be recursed thru Out	 * @return Void 	 */	public function object (origin:Object, obj:Object):Void {		 var insp:Inspector = new Inspector(obj,origin);		_output ("OBJECT",origin,insp);	}}