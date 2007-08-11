﻿/** * com.sekati.log.OutPanel * @version 1.9.0 * @author jason m horwitz | sekati.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */import com.sekati.log.Out;import com.sekati.events.Event;import com.sekati.events.Dispatcher;import com.sekati.utils.Delegate;import flash.filters.DropShadowFilter;/** * Creates a panel within current swf for live debugging via {@link com.sekati.log.Out}.  * Can be toggled on/off with hotkey [Shift+Right Arrow] or [Shift + Left Arrow] * Can clear panel output with hotkey [Shift + Backspace] or [Shift + Delete] *  * XXX - !!! NOTE: v1.9.0 is under heavy construction - please revert to earlier version in SVN for working version!!! * TODO Add resizable panel feature * TODO Add LocalConnection support *  * {@code Usage: * OutPanel.getInstance(640,480); * -or- * var out:Out = Out.getInstance(); * out.createPanel(640,480); * } */class com.sekati.log.OutPanel {	// Constant & Static Properties	public static var CLASSNAME:String = "OutPanel";	public static var VERSION:String = "1.7.3";	public static var AUTHOR:String = "Sekati";	public static var URI:String = "http://sekati.com";	public static var ID:String = AUTHOR + "." + CLASSNAME + " v" + VERSION;	private static var _instance:OutPanel;	// UI Properties	private var _this:OutPanel;	private var _outPanel:MovieClip;	private var _box:MovieClip;	private var _handle:MovieClip;	private var _szhandle:MovieClip;	private var _headTf:TextField;	private var _fpsTf:TextField;	private var _outTf:TextField;	private static var ui:Object = {_width:680, _height:450, _x:10, _y:10, _alpha:85, _szsize:11, _handleHeight:15,									_scrollWidth:10, _scrollHeightOffset:31, _scrollxOffset:11, _scrollyOffset:17, _szOffset:1, _barHeight:150, 									_borderColor:0x333333, _boxColor:0xFFFFFF, _handleColor:0x3A3A3A, _titleColor:0xFFFF00, 									_outColor:0x000000, _szColor: 0xFF6600, _gutterColor:0xCCCCCC, _barColor:0x666666};	// Scroll Properties	private var _scroller:MovieClip;	private var _gutter:MovieClip;	private var _bar:MovieClip;	private var _g:MovieClip;	private var _b:MovieClip;	private var _s:MovieClip;	private var _isDrag:Boolean = false;	private var _isResize:Boolean = false;	// Event Handler Properties	private var _fps:Number;	private var _startTime:Number;	private var _totalTime:Number;	private var _keyListener:Object;	/**	 * Singleton Private Constructor	 */	private function OutPanel() {		_this = this;		initUI();		Dispatcher.$.addEventListener("OUT_EVENT",Delegate.create (this, eventHandler));	}	/**	 * Singleton Accessor	 * @param w (Number) panel width	 * @param h (Number) panel height	 * @return OutPanel	 */		public static function getInstance(w:Number, h:Number):OutPanel {		if (!_instance) {			if (w && h) {				ui._width = w;				ui._height = h;			}			_instance = new OutPanel();		}		return _instance;	}	/**	 * shorthand singleton accessor getter	 */	 public static function get $():OutPanel {	 	return OutPanel.getInstance();		 }		private function eventHandler(eventObj:Event):Void {		//trace ("eventObj{target:" + eventObj.target + ",type:" + eventObj.type + ",message:" + eventObj.data.message + "};");		_outTf.text += eventObj.data.message + "\n";		_outTf.scroll = _outTf.maxscroll;		updateBar();	}	private function clearOutput():Void {		//trace ("clear");		_outTf.text = "";		updateBar();	}	/**	 * ui methods	 */	 private function resizePanel():Void {	 	trace("re");	 	var newW:Number = _szhandle._x + ui._szsize + ui._szOffset;	 	var newH:Number = _szhandle._y + ui._szsize + ui._szOffset;	 	ui._width = newW;	 	ui._height = newH;	 	//initUI();	 		 	//_szhandle._x + ui._szsize, _szhandle._y + ui._szsize			/*		drawRect (_box, w, h, c, c2, a, true);		_debug._width = (w/2) -10;		_debug._height = h-30;				_tdebug._width = (w/2) -10;		_tdebug._x = (w/2) +5;		_tdebug._height = h-30;		_handle._width = w;		_header._width = _fpsf._x = w-50;		 */		 		 /*		  	//CC debug			drawRect (_box, w, h, c, c2, a, true);				_debug._width = (w/2) -10;		_debug._height = h-30;				_tdebug._width = (w/2) -10;		_tdebug._x = (w/2) +5;		_tdebug._height = h-30;		_handle._width = w;		_header._width = _fpsf._x = w-50;		  */	 }	private function initUI():Void {		// main panel container with dropshadow		var _outPanel:MovieClip = _level0.createEmptyMovieClip ("_outPanel", _level0.getNextHighestDepth ());		_outPanel._visible = false; 		_outPanel.cacheAsBitmap = true;		_outPanel._x = ui._x;		_outPanel._y = ui._y;		var ds:DropShadowFilter = new DropShadowFilter (3, 45, 0x000000, .5, 5, 5, 1, 3, false, false, false);		_outPanel.filters = [ds];					var _box:MovieClip = _outPanel.createEmptyMovieClip ("_box", _outPanel.getNextHighestDepth ());		drawRect (_box, ui._width, ui._height, ui._boxColor, ui._borderColor, ui._alpha, true);		var _handle:MovieClip = _outPanel.createEmptyMovieClip ("_handle", _outPanel.getNextHighestDepth ());		drawRect (_handle, ui._width, ui._handleHeight, ui._handleColor, ui._borderColor, ui._alpha, true);		// create scroller		var _scroller:MovieClip = _outPanel.createEmptyMovieClip ("_scroller", _outPanel.getNextHighestDepth ());		_scroller._visible = false; 		_scroller._x = (ui._width - ui._scrollxOffset); 		_scroller._y = ui._scrollyOffset;		var _gutter:MovieClip = _scroller.createEmptyMovieClip ("_gutter", _scroller.getNextHighestDepth ());		drawRect (_gutter, ui._scrollWidth, (ui._height-ui._scrollHeightOffset), ui._gutterColor, ui._gutterColor, 100, false);		var _bar:MovieClip = _scroller.createEmptyMovieClip ("_bar", _scroller.getNextHighestDepth ());		drawRect (_bar, ui._scrollWidth, ui._barHeight, ui._barColor, ui._barColor, 100, false);		// create refs		_s = _level0._outPanel._scroller; 		_g = _s._gutter;		_b = _s._bar;		// create textfields		_headTf = createTf (_outPanel, "_headTf", 5, 0, (ui._width - 50), 20, {html:true, selectable:false, htmlText:ID}, {color:ui._titleColor, url:URI});		_fpsTf = createTf (_outPanel, "_fpsTf", (ui._width - 50), 0, 50, 20, {selectable:false}, {color:ui._titleColor});		_outTf = createTf (_outPanel, "_outTf", 5, 20, (ui._width - 20), (ui._height - 25), {type:"dynamic", mouseWheelEnabled:true, wordWrap:true, border:false, multiline:true, selectable:true}, {color:ui._outcolor});		// resize handle		var _szhandle:MovieClip = _outPanel.createEmptyMovieClip ("_szhandle", _outPanel.getNextHighestDepth());		_szhandle._x = ui._width - ui._szsize - ui._szOffset;		_szhandle._y = ui._height - ui._szsize - ui._szOffset;		drawTriangle (_szhandle, ui._szsize, ui._szColor);		// event handlers		_outPanel.onEnterFrame = Delegate.create (_this, _onEnterFrame);				_handle.onPress = Delegate.create (_outPanel, startDrag);		_handle.onRelease = _handle.onReleaseOutside = Delegate.create (_outPanel, stopDrag);						_szhandle.onPress = Delegate.create(_this, szhandle_onPress);		_szhandle.onRelease = _szhandle.onReleaseOutside = Delegate.create(_this, szhandle_onRelease);				_bar.onPress = Delegate.create (_this, bar_onPress);		_bar.onRelease = _bar.onReleaseOutside = Delegate.create (_this, bar_onRelease);				_gutter.onPress = Delegate.create (_this, gutter_onPress);				_outTf.onChanged = Delegate.create (_this, updateBar);				_keyListener = new Object ();		_keyListener.onKeyDown = function ():Void  {			if ((Key.isDown (Key.SHIFT) && Key.isDown (Key.RIGHT)) || (Key.isDown (Key.SHIFT) && Key.isDown (Key.LEFT))) {				_outPanel._visible = !_outPanel._visible;			}			if ((Key.isDown (Key.SHIFT) && (Key.isDown (Key.BACKSPACE) || Key.isDown (Key.DELETEKEY)))) {				Delegate.create (_this,clearOutput);			}		};		Key.addListener (_keyListener);	}	private function createTf (scope:MovieClip, instanceName:String, x:Number, y:Number, w:Number, h:Number, props:Object, fprops:Object):TextField {		var t:TextField = scope.createTextField (instanceName, scope.getNextHighestDepth (), x, y, w, h);		for (var i in props) {			//t.border = true;			t.embedFonts = false;			t.antiAliasType = "normal";			t.gridFitType = "pixel";			t.sharpness = 400;			t.thickness = 0;			t[i] = props[i];		}		if (fprops) {			var f:TextFormat = new TextFormat ();			f.font = "Verdana";			f.kerning = true;			f.size = 9;			for (var j in fprops) {				f[j] = fprops[j];			}			t.setNewTextFormat (f);		}		if (props.text) {			t.text = props.text;		} else if (props.htmlText) {			t.htmlText = props.htmlText;		}		return t;	}	private function drawRect (mc:MovieClip, w:Number, h:Number, color:Number, borderColor:Number, alpha:Number, isBorder:Boolean):Void {		var l:Number = (!isBorder) ? undefined : 1;		mc.clear();		mc.lineStyle (l,borderColor,alpha,true,"none","square","miter",1.414);		mc.beginFill (color,alpha);		mc.moveTo (0,0);		mc.lineTo (w,0);		mc.lineTo (w,h);		mc.lineTo (0,h);		mc.endFill ();	}	private function drawTriangle (mc:MovieClip, s:Number, c:Number):Void {		mc.lineStyle (undefined,0x000000,100,true,"none","square","miter",1.414);		mc.beginFill (c,100);		mc.moveTo (0,s);		mc.lineTo (s,s);		mc.lineTo (s,0);		mc.lineTo (0,s);	}	/**	 * Event methods	 */	 private function szhandle_onPress():Void {	 	//_isResize = true;	 	_szhandle.startDrag(false,0,0,1000,1000);	 	//_szhandle.startDrag();	 }	 	 private function szhandle_onRelease():Void {	 	//_isResize = false;	 	_szhandle.stopDrag();		//resizePanel();	 }	 	private function bar_onPress():Void {		_isDrag = true;		_b.startDrag(false,_b._x,_g._y,_bar._x,(_g._y + _g._height - _b._height));	}	private function bar_onRelease():Void {		_isDrag = false;		_b.stopDrag();	}		private function gutter_onPress():Void {		var newY:Number = constrain (_g._ymouse, _g._y, _g._height - _b._height);		_b._y = newY;		updateScroll();	}		private function updateScroll():Void {		var _gutterTop:Number = _g._y;		var _gutterBot:Number = _g._height - _b._height;		var percent:Number = int ((_b._y - _gutterTop) / (_gutterBot - _gutterTop) * 100);		var newScroll:Number = _outTf.maxscroll * percent / 100;		_outTf.scroll = newScroll;	}		private function updateBar():Void {		_s._visible = isScrollable ();		if (!_s._visible) {			return;		}		var _gutterTop:Number = _g._y;		var _gutterBot:Number = _g._height - _b._height;		var percent:Number = int (_outTf.scroll * 100 / _outTf.maxscroll);		var newPos:Number = (_gutterBot - _gutterTop) * percent / 100;		_b._y = constrain (newPos);	}		private function isScrollable():Boolean {		return (_outTf.textHeight > _outTf._height);	}		private function constrain(val:Number, min:Number, max:Number):Number {		if (val < min) {			val = min;		} else if (val > max) {			val = max;		}		return val;	}		private function _onEnterFrame():Void {		fpsMonitor();		if(_isResize) {			//trace("doin a resizer!");			resizePanel();			}		if (_isDrag) {			updateScroll();		}	}		private function fpsMonitor():Void {		_totalTime = getTimer () - _startTime;		_fps = Math.round (1000 / this._totalTime);		_startTime = getTimer ();		_fpsTf.text = " FPS: " + _fps;	}}