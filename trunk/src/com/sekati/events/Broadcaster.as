﻿/** * com.sekati.events.Broadcaster * @version 3.6.5 * @author jason m horwitz | sekati.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ import com.sekati.core.CoreObject; import com.sekati.events.IBroadcastable; import com.sekati.reflect.Stringifier;/** * Singleton Broadcaster with bulk subscribe/unsubscribe & the  * ability to pass arguments through broadcast events. *  * {@code Usage: * var bc:Broadcaster = Broadcaster.getInstance (); * bc.subscribe (fooMc); * bc.broadcast ("onChangeAlpha", 50); * } * @see {@link com.sekati.events.Dispatcher} */class com.sekati.events.Broadcaster extends CoreObject implements IBroadcastable {	private static var _instance:Broadcaster;	private var _listeners:Array;	/**	 * Singleton Private Constructor	 */	private function Broadcaster() {		super();		_listeners = new Array ();	}		/**	 * Singleton Accessor	 * @return Broadcaster	 */	public static function getInstance ():Broadcaster {		if (!_instance) {			_instance = new Broadcaster ();		}		return _instance;	}	/**	 * shorthand singleton accessor getter	 */	 public static function get $():Broadcaster {	 	return Broadcaster.getInstance();		 }		/**	 * subscribe an object or array of objects as listeners to the Broadcaster.	 * Note: movieclips will automatically unsubscribe onUnload	 * @param o (Object) Object or Array of Object to subscribe	 * @return Void	 * {@code Usage:	 * Broadcaster.getInstance().subscribe( [fooMc, barMc] );	 * }	 */	public function subscribe (o:Object):Void {		if (o instanceof Array) {			for (var i:Number = 0; i < o.length; i++) {				addListener (o[i]);				if (typeof (o[i]) == "movieclip") {					o[i].onUnload = function () {						removeListener (o[i]);					};				}			}		} else {			addListener (o);		}	}	/**	 * unsubscribe an object or array of objects from  Broadcaster 	 * @param o (Object) Object or Array of Object to unsubscribe	 * @return Void	 * {@code Usage:	 * Broadcaster.getInstance().unsubscribe( [fooMc, barMc] );	 * }	 */	public function unsubscribe (o:Object):Void {		if (o instanceof Array) {			for (var i:Number = 0; i < o.length; i++) {				removeListener (o[i]);			}		} else {			removeListener (o);		}	}		/**	 * Clear all listeners and reset the broadcaster.	 * @return Void	 */	public function reset ():Void {		_listeners = new Array ();	}		/**	 * Broadcast event message to all subscribed listeners	 * @param e (String) event name to broadcast to subscribed listeners (extra arguments will be passed to listener event methods!)	 * @return Void	 */	public function broadcast ():Void {		var e:String = String (arguments.shift ());		var a:Array = this._listeners.concat ();		var l:Number = a.length;		//var m:String = "@@@ Broadcast: \"" + e + "\"";		//if(App.DEBUG_ENABLE) App.debug.trace(m); else trace(m);		for (var i = 0; i < l; i++) {			a[i][e].apply (a[i], arguments);		}	}		/**	 * add listener to broadcaster	 * @param o (Object)	 * @return Number	 */	public function addListener (o:Object):Number {		this.removeListener (o);		return this._listeners.push (o);	}		/**	 * remove listener from broadcaster	 * @param o (Object)	 * @return Boolean	 */	public function removeListener (o:Object):Boolean {		var a:Array = this._listeners;		var i:Number = a.length;		while (i--) {			if (a[i] == o) {				a.splice (i, 1);				return true;			}		}		return false;	}		/**	 * Destroy singleton instance.	 * @return Void	 */	public function destroy():Void {		delete _listeners;		delete _instance;		super.destroy();	}	}