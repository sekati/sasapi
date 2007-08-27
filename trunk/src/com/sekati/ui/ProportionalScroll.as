/**
 * com.sekati.ui.ProportionalScroll
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
class com.sekati.ui.ProportionalScroll {

	// ui elements
	private var _this:ProportionalScroll;
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

	// optional settings	
	private var _isResizeGutter:Boolean = true;
	private var _isResizeBar:Boolean = true;
	private var _isMouseWheelEnabled:Boolean = true;
	private var _speed:Number = 0;
	private var _friction:Number = 0.8;
	private var _ratio:Number = 0.5;

	/**
	 * 
	 */
	public function ProportionalScroll (axis:String, content:Object, contentSizeTracker:Object, mask:MovieClip, gutter:MovieClip, bar:MovieClip, isInit:Boolean) {
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
		setConfines ();
		setMouseWheel ();
		scroller_onRollOut ();
		// define event handlers
		_scroller.onRollOver = Delegate.create (_this, scroller_onRollOver);
		_scroller.onDragOver = Delegate.create (_this, scroller_onRollOver);
		_scroller.onRollOut = Delegate.create (_this, scroller_onRollOut);
		_scroller.onDragOut = Delegate.create (_this, scroller_onRollOut);
		_scroller.onPress = Delegate.create (_this, scroller_onPress);
		_scroller.onRelease = Delegate.create (_this, scroller_onRelease);
		_scroller.onReleaseOutside = Delegate.create (_this, scroller_onReleaseOutside);
		_gutter.onPress = Delegate.create (_this, gutter_onPress);
		
		Pulse.getInstance().addFrameListener(_this);
	}	
	//////////////////////////////////////////////////////////////
	// Core Logic
	
	//////////////////////////////////////////////////////////////
	// Core Controllers
	
	//////////////////////////////////////////////////////////////
	// UI Controllers			

	//////////////////////////////////////////////////////////////
	// User Config
		
	public function config(isResizeGutter:Boolean, isResizeBar:Boolean, isMouseWheelEnabled:Boolean, friction:Number, ratio:Number):Void {
		_isResizeGutter = (!isResizeGutter) ? false : true;
		_isResizeBar = (!isResizeBar) ? false : true;
		_isMouseWheelEnabled = (!isMouseWheelEnabled) ? false : true;
		
	}
}