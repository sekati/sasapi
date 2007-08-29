/**
 * com.sekati.log.Console
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip; 
import com.sekati.events.Dispatcher;
import com.sekati.events.Event;
import com.sekati.log.ConsoleFPSMonitor;
import com.sekati.log.ConsoleItem;
import com.sekati.log.ConsoleStyle;
import com.sekati.log.LogConsoleConnector;
import com.sekati.log.LogEvent;
import com.sekati.ui.Scroll;
import com.sekati.utils.ClassUtils; 
import com.sekati.utils.Delegate;
 
/**
 * UI Console for attaching or connecting too
 */
class com.sekati.log.Console {
	
	// core console props
	private static var _instance:Console;
	private var _this:Console;
	private var _cs:ConsoleStyle;
	private var _style:Object;
	
	// ui props
	private var _console:MovieClip;
	private var _head:MovieClip;
	private var _headTf:TextField;
	private var _fps:MovieClip;
	private var _holder:MovieClip;
	private var _list:MovieClip;
	private var _mask:MovieClip;
	private var _scroll:Scroll;
	private var _gutter:MovieClip;
	private var _bar:MovieClip;
	
	// manager props
	private var _logItems:Array;
	private var _logIndex:Number;
	private var _key:Object;
	private var _rx_lc:LocalConnection;
	
	/**
	 * Singleton Private Constructor
	 */
	private function Console() {
		_this = this;
		_cs = ConsoleStyle.getInstance();
		_style = _cs.CSS;
		Dispatcher.$.addEventListener(LogEvent.onLogEVENT, Delegate.create (_this, onLogEvent));
		logConsoleConnect();
		createUI();
	}

	/**
	 * Singleton Accessor
	 * @return Console
	 */	
	public static function getInstance():Console {
		if (!_instance) {
			_instance = new Console();
		}
		return _instance;
	}

	/**
	 * shorthand singleton accessor getter
	 */
	 public static function get $():Console {
	 	return Console.getInstance();	
	 }
	
	/**
	 * Create the core Console UI
	 */
	private function createUI():Void {
		// rect	- createStyledRect (target:MovieClip, style:Object)
		_console = _cs.createStyledRectangle(_level0, _style.console);
		_console._quality = "LOW";
		//_console._visible = false;
		
		_head = _cs.createStyledRectangle(_console, _style.console.head);
		
		// text - createStyledTextField (target:MovieClip, style:Object, str:String)
		_headTf = _cs.createStyledTextField(_head, _style.console.head.textfields.head);
		
		// create ConsoleFPSMonitor
		_fps = ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleFPSMonitor, _head, _style.console.head.fps.n, {_x:_style.console.head.fps.x, _y:_style.console.head.fps.y});		
		
		// create core ui clip holders
		_holder = _cs.createPositionClip(_console, _style.console.holder);
		_list = _cs.createPositionClip(_holder, _style.console.holder.list);
		
		// create core ui clip shapes
		_mask = _cs.createStyledRectangle(_holder, _style.console.holder.mask);
		_gutter = _cs.createStyledRectangle(_holder, _style.console.holder.gutter);
		_gutter.cacheAsBitmap = true;
		_bar = _cs.createStyledRectangle(_holder, _style.console.holder.bar);
		_bar.cacheAsBitmap = true;
		_bar._visible = false;
		
		// mask item list
		_list.setMask(_mask);
		
		// create scrollable functionality
		_scroll = new Scroll("_y", _list, _mask, _gutter, _bar, true, true, true, true, _list, 0.05, 0.5);
	
		// EVENTS start
		
		// make console draggable
		_head.onPress  = Delegate.create (_console, startDrag);
		_head.onRelease = _head.onReleaseOutside = Delegate.create (_console, stopDrag);
		
		// EVENTS stop
		
		// position the console on stage.
		_console._x = _style.console.startx;
		_console._y = _style.console.starty;
		
		// create the meta item
		ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleItem, _list, "metaItem", {_x:0, _y:0, _data:{_isMeta:true}});
		
		//runItemTest();
		
		// keylistener
		_key = new Object ();
		_key.onKeyDown = Delegate.create(_instance, key_onKeyDown);
		/*
		_key.onKeyDown = function ():Void  {
			if (Key.isDown (Key.UP) && Key.isDown (Key.LEFT)) {
				trace("key");
				_console._visible = (!_console._visible) ? true : false;
			}
		};
		*/
		Key.addListener (_key);		
	}
	
	/**
	 * Key Handler for all Console hotkeys.
	 * @return Void
	 */
	private function key_onKeyDown(code:Number):Void {
		//trace("keydel: "+code);
		if (Key.isDown (Key.UP) && Key.isDown (Key.LEFT)) {
			trace("key");
			_console._visible = (!_console._visible) ? true : false;
		}		
	}
	
	/**
	 * Create a LocalConnection to Logger
	 * @return Void
	 */
	private function logConsoleConnect():Void {
		_rx_lc = new LocalConnection();
		_rx_lc[LogConsoleConnector.methodName]= Delegate.create(_this, addItem);
		_rx_lc.connect(LogConsoleConnector.connectionName);
	}
	
	/**
	 * Add and return a new ConsoleItem
	 * @param data (Object) ConsoleItem._data = {id:Number, type:String, origin:String, message:String, benchmark:Number, _isMeta:Boolean}
	 * @return 	MovieClip
	 */
	public function addItem (data:Object):MovieClip {
		var item:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleItem, _list, "consoleItem_"+data.id, {_x:0, _y:_list._height, _data:data});
		updateScroll(item);
		return item;
	}
	
	/**
	 * Update the {@link Scroll} to the last added item if we are not mousing the area.
	 * @param item (MovieClip) last added item
	 * @return Void
	 */
	public function updateScroll(item:MovieClip):Void {
		if(!_scroll.isMouseInArea() && !_scroll.isDrag && _console._visible == true) {
			_global['setTimeout'](_scroll,'slideContent',50, item._y+item._height, 0.1);
		}
	}
	
	/**
	 * Handle events from Logger and parse them to addItem
	 * @param eventObj (Event)
	 * @return Void
	 */ 
	private function onLogEvent (eventObj:Event):Void {
		//trace ("eventObj{target:" + eventObj.target + ",type:" + eventObj.type + ",message:" + eventObj.data.message + "};");
		addItem(eventObj.data);
	}
	
	/**
	 * Clean and destroy
	 * @return Void
	 */
	public function destroy():Void {
		Dispatcher.$.removeEventListener("LOG_EVENT",Delegate.create (_this, onLogEvent));
		_rx_lc.close();
		_fps.destroy();
	}
}