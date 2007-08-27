/**
 * com.sekati.ui.Scroller
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.events.Pulse;
 import com.sekati.external.MouseWheel;
 import com.sekati.math.MathBase;
 import com.sekati.utils.Delegate;
 import mx.transitions.easing.Strong;
 import mx.transitions.Tween;
 
/**
 * 
 */
class com.sekati.ui.Scroller {

	// ui elements
	private var _this:Scroller;
	private var _content:Object;
	private var _contentSizeTracker:Object;
	private var _mask:MovieClip;	
	private var _gutter:MovieClip;
	private var _bar:MovieClip;

	// tracking properties
	private var _axis:String;
	private var _prop:String;
	private var _contentTop:Number;
	private var _contentBot:Number;
	private var _gutterTop:Number;
	private var _gutterBot:Number;
	private var _oldPos:Number;
	private var _newPos:Number;

	// motion
	private var _isDragged:Boolean = false;
	private var _slide:Tween;

	// optional setting
	private var _isMouseWheelEnabled:Boolean;
	private var _speed:Number;
	private var _friction:Number;
	private var _ratio:Number;

	/**
	 * Proportional scroller with support for dynamically resizing content.
	 */
	public function Scroller (axis:String, content:Object, contentSizeTracker:Object, mask:MovieClip, gutter:MovieClip, bar:MovieClip, isInit:Boolean, friction:Number, ratio:Number) {
		// scrolling axis is critical - throw an error and force breakage to gain attention
		if (axis != "_x" && axis != "_y") {
			throw new Error ("@@@ com.sekati.ui.Scroll Error: constructor expects axis param: '_x' or '_y'.");
			return;
		}
		                                
		_this = this;
		_axis = axis;
		_prop = (_axis == "_y") ? "_height" : "_width";
		_content = content;
		_contentSizeTracker = (!contentSizeTracker) ? content : contentSizeTracker;
		_gutter = gutter;
		_bar = bar;
		_mask = mask;
				
		// only MouseWheel vertically as we may have multiple Scrol instances on same content.
		_isMouseWheelEnabled = (_axis == "_y") ? true : false;
		_speed = 0;
		
		// optional user defined motion settings
		_friction = (friction) ? friction : 0.8;
		_ratio = (ratio) ? ratio : 0.5;		
		
		if (isInit) {
			init ();
		}
	}
	
	/**
	 * initialize scroll behavior 
	 * @return Void
	 */
	public function init ():Void {
		// define confines, mouseWheel, and set scroller to rollout color state
		setConfines();
		initMouseWheel();
		// define event handlers
		_bar.onPress = Delegate.create (_this, bar_onPress);
		_bar.onRelease = _bar.onReleaseOutside = Delegate.create (_this, bar_onRelease);
		_gutter.onPress = Delegate.create (_this, gutter_onPress);
		
		Pulse.getInstance().addFrameListener(_this);
	}	
	//////////////////////////////////////////////////////////////
	// Core Logic
	
	private function setConfines ():Void {
		_contentTop = _content[_axis];
		_gutterTop = _gutter[_axis];
		_gutterBot = _gutter[_axis] + _gutter[_prop];
		// set content related confines (isloated since may need to be called on size change)
		updateConfines ();
	}
	
	private function updateConfines ():Void {
		
		_contentBot = _contentTop + _contentSizeTracker[_prop];
		
		//scale scroller bar in proportion to the content to scroll
		var percent:Number = (_gutterBot - _gutterTop) / (_contentBot - _contentTop);
		
		_bar[_prop] = MathBase.constrain (Math.round ((_gutterBot - _gutterTop) * percent), _gutterTop, _gutterBot);
		//_bar[_prop] = Math.round ((_gutterBot - _gutterTop) * percent), _gutterTop, _gutterBot;
		
		//get new gutterBot with new size of scrollerbar                               
		_gutterBot = _gutter[_axis] + _gutter[_prop] - _bar[_prop];
	}
	
	//////////////////////////////////////////////////////////////
	// Core Logic

	//////////////////////////////////////////////////////////////
	// GETTERS & SETTERS
	
	//////////////////////////////////////////////////////////////
	// UI Event Logic
	
	private function bar_onPress():Void {	
	}
	private function bar_onRelease():Void {
	}
	private function gutter_onPress():Void {
	}
	private function _onEnterFrame():Void {
	}

	//////////////////////////////////////////////////////////////
	// MouseWheel Logic
	private function initMouseWheel ():Void {
		if (_isMouseWheelEnabled) {
			//deactivate mousewheel on textfield & activate mouse listener
			_content.mouseWheelEnabled = false;
			// setup Mac/PC MouseWheel support
			MouseWheel.init(_this);
		}
	}
	
	private function isMouseInArea () {
		var x:Number = _content._parent._xmouse;
		var y:Number = _content._parent._ymouse;
		return (x >= 0 && x <= _mask._width && y >= 0 && y <= _mask[_prop]);
	}
	
	private function onMouseWheel (delta:Number) {
		if (isMouseInArea () && isScrollable ()) {
			var m:Number = _scroller[_axis] - ((_gutter[_prop] / 5) * (delta / 3));
			slideScroller (m);
		}
	}	

	//////////////////////////////////////////////////////////////
	// EOF
}