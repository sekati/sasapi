/**
 * com.sekati.log.Console
 * @version 1.1.0
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
		Dispatcher.$.addEventListener("LOG_EVENT", Delegate.create (_this, onLogEvent));
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
		_bar = _cs.createStyledRectangle(_holder, _style.console.holder.bar);
		_bar._visible = false;
		
		// mask item list
		_list.setMask(_mask);
		
		// create scrollable functionality
		//_scroll = new Scroll("_y", _list, _mask, _gutter, _bar, true, true, true, true, _list);
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
		_key.onKeyDown = function ():Void  {
			if (Key.isDown (Key.UP) && Key.isDown (Key.LEFT)) {
				_console._visible = !_console._visible;
			}
			/*
			if ((Key.isDown (Key.SHIFT) && (Key.isDown (Key.BACKSPACE) || Key.isDown (Key.DELETEKEY)))) {
				Delegate.create (_this,clearOutput);
			}
			 */
		};
		Key.addListener (_key);		
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
	 * create a test set of data Items for ConsoleItem test.
	 * TODO remove me!
	 */
	private function runItemTest():Void {
		// create a block of consoleItems.
		var lipsum0:String = "Sed enim. Sed ac augue et elit lacinia sodales. Nunc ultricies est in leo. Nunc nulla mi, rhoncus eget, dignissim a, tincidunt quis, ligula. Nulla facilisi. Aenean luctus, metus id pharetra ullamcorper, est odio fringilla justo, commodo blandit ante lacus id nulla. Nulla vel orci a nunc malesuada elementum. Sed augue tortor, pellentesque a, tristique quis, lacinia id, purus. Suspendisse potenti. Pellentesque venenatis eros sit amet metus. Morbi convallis enim at massa aliquet bibendum.";
		var lipsum1:String = "\n\nVestibulum eget urna vitae ante venenatis sodales. Nam adipiscing blandit odio. Nulla facilisi. Donec ultrices turpis at lacus. Cras sit amet turpis. Vivamus at justo. Aenean blandit tortor sit amet ante. Praesent scelerisque massa eu metus. Mauris nec metus. Phasellus at elit non dui tincidunt eleifend. Mauris congue placerat dui.";
		
		var data0:Object = {id:0, type:"trace", origin:"_level0.myArr[3]", message:lipsum0, benchmark:0.122};
		var data1:Object = {id:1, type:"info", origin:"_level0", message:"Generic status report.", benchmark:0.3339};
		var data2:Object = {id:2, type:"status", origin:"Dispatcher", message:"Generic info report.", benchmark:1.19};
		var data3:Object = {id:3, type:"warn", origin:"myClass.isWrong", message:"Generic warn report.\n\n"+lipsum0+lipsum1, benchmark:0.29};
		var data4:Object = {id:4, type:"error", origin:"Scroll", message:"Generic error report.", benchmark:0.01};
		var data5:Object = {id:5, type:"fatal", origin:"Document.main", message:"Generic fatal report.", benchmark:0.01};
		var data6:Object = {id:6, type:"object", origin:"App.db", message:"Custom Object report.", benchmark:13.0012};
		var data7:Object = {id:6, type:"custom", origin:"TextUtils.test", message:"Custom report.", benchmark:1.0012};
		addItem(data0);
		addItem(data1);
		addItem(data2);
		addItem(data3);
		addItem(data4);
		addItem(data5);	
		addItem(data6);	
		addItem(data7);			
	}
	
	/**
	 * Add and return a new ConsoleItem
	 * @param data (Object) ConsoleItem._data = {id:Number, type:String, origin:String, message:String, benchmark:Number, _isMeta:Boolean}
	 * @return 	MovieClip
	 */
	public function addItem (data:Object):MovieClip {
		var item:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleItem, _list, "consoleItem_"+data.id, {_x:0, _y:_list._height, _data:data});
		
		_global['setTimeout'](_scroll,'slideContent',50, item._y+item._height);

		return item;
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
}