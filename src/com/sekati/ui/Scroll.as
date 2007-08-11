﻿/** * com.sekati.ui.Scroll * @version 5.0.0 * @author jason m horwitz | sekati.com * Copyright (c) 2007  jason m horwitz | Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */import com.sekati.events.Broadcaster;import com.sekati.external.MouseWheel;import com.sekati.utils.Delegate;import mx.transitions.easing.Strong;import mx.transitions.Tween; /** * Scroll handles mouseWheel (pc & mac), dynamic resizing of content, external size tracking  * for accordian style content scrolling, slideContent method, modal ui states,  * proportional scroller, gutter and more.  *  * {@code Usage: *  var _scroll:Scroll = new com.sekati.ui.Scroll("_y", contentMc, maskMc, gutterMc, barMc, true, true, true, true); *  var _scroll:Scroll = new com.sekati.ui.Scroll ("_y", contentMc, maskMc, scrollbar.gutter, scrollbar.bar, true, true, true, true, contentMc, .8, .5, {up:0xFFFFFF, over:0x333333}); * } *  * TODO: currently scroller only repositions to accomodate content size change scrollbar  * 		 requires proportionally resizing to content size change as well (all attempts * 		 thus far produce inaccuracy/bugs. fix would remove need to re-call init upon  * 		 major content change)  */ class com.sekati.ui.Scroll {	private var _this:Scroll;	private var _axis:String;	private var _prop:String;	private var _content:Object;	private var _gutter:MovieClip;	private var _scroller:MovieClip;	private var _mask:MovieClip;	private var _isDragged:Boolean;	private var _isResizeScroller:Boolean;	private var _isResizeGutter:Boolean;	private var _isMouseWheelEnabled:Boolean;	private var _speed:Number;	private var _contentTop:Number;	private var _contentBot:Number;	private var _contentSizeTracker:Object;	private var _gutterTop:Number;	private var _gutterBot:Number;	private var _oldPos:Number;	private var _newPos:Number;	private var _friction:Number;	private var _ratio:Number;	private var _colors:Object;	private var _slide:Tween;	/**	 * Constructor	 * @param axis (String) axis the scroller will scroll on: must be "_x" or "_y"	 * @param content (Object) content object	 * @param mask (MovieClip) content mask	 * @param gutter (MovieClip) gutter object	 * @param scroller (MovieClip) scroller bar object	 * @param isResizeGutter (Boolean) optional resize gutter to content mask	 * @param isResizeScroller (Boolean) optional resize scroller bar proportional to content	 * @param isMouseWheelEnabled (Boolean) optional enable mouseWheel scrolling (one may choose to use 2 instances of Scroll for hscroll & vscroll and only want vscroll in which case mouseWheel should only be enabled for one instance)	 * @param isInit (Boolean) optional init scroller upon instantiation, else {@link #init()} must be called manually	 * @param contentSizeTracker (Object) optional object used to track content size. Useful in accordian content where visibility or masking is used to hide partial content [default: content]	 * @param friction (Number) optional scroll motion friction [default 0.8] 	 * @param ratio (Number) optional scroll motion ratio  [default 0.5]	 * @param colors (Object) optional scroller bar modal event color settings {up:0xCCCCCC, over:0xFFFFFF}	 * @return Void	 * @throws Error if axis is not "_x" or "_y" & returns without proper instantiation	 */	public function Scroll (axis:String, content:Object, mask:MovieClip, gutter:MovieClip, scroller:MovieClip, isResizeGutter:Boolean, isResizeScroller:Boolean, isMouseWheelEnabled:Boolean, isInit:Boolean, contentSizeTracker:Object, friction:Number, ratio:Number, colors:Object) {		// scrolling axis is critical - throw an error and force breakage to gain attention		if (axis != "_x" && axis != "_y") {			throw new Error ("@@@ com.sekati.ui.Scroll Error: constructor expects axis param: '_x' or '_y'.");			return;		}		// user defined                                 		_this = this;		_axis = axis;		_content = content;		_gutter = gutter;		_scroller = scroller;		_mask = mask;		_contentSizeTracker = (!contentSizeTracker) ? content : contentSizeTracker;		_isResizeScroller = (!isResizeScroller) ? false : true;		_isResizeGutter = (!isResizeGutter) ? false : true;		_isMouseWheelEnabled = (!isMouseWheelEnabled) ? false : true;		_friction = (friction) ? friction : 0.8;		_ratio = (ratio) ? ratio : 0.5;		_colors = (colors) ? colors : {};		// class defined		_prop = (_axis == "_y") ? "_height" : "_width";		_isDragged = false;		_speed = 0;				// auto init on request ...		if (isInit) {			init ();		}	}		/**	 * initialize scroll behavior 	 * @return Void	 */	public function init ():Void {		// define confines, mouseWheel, and set scroller to rollout color state		setConfines ();		setMouseWheel ();		scroller_onRollOut ();		// define event handlers		_scroller.onRollOver = Delegate.create (_this, scroller_onRollOver);		_scroller.onDragOver = Delegate.create (_this, scroller_onRollOver);		_scroller.onRollOut = Delegate.create (_this, scroller_onRollOut);		_scroller.onDragOut = Delegate.create (_this, scroller_onRollOut);		_scroller.onPress = Delegate.create (_this, scroller_onPress);		_scroller.onRelease = Delegate.create (_this, scroller_onRelease);		_scroller.onReleaseOutside = Delegate.create (_this, scroller_onReleaseOutside);		_scroller.onEnterFrame = Delegate.create (_this, scroller_onEnterFrame);		_gutter.onPress = Delegate.create (_this, gutter_onPress);	}		/**	 * tween content to position, scroller will reposition accordingly	 * @param pos (Number) position to slide content on axis	 * @return Void	 */	public function slideContent (pos:Number):Void {		var newScrollPos:Number = (_contentTop - pos) * (_gutterBot - _gutterTop) / (_gutterBot - _contentBot + _scroller[_prop]) + _gutterTop;		slideScroller (newScrollPos);	}		/**	 * tween scroller to position, content will reposition accordingly	 * @param pos (Number) position to slide scroller on axis	 * @return Void	 */	public function slideScroller (pos:Number) {		stopScroller ();		_slide = new Tween (_scroller, _axis, Strong.easeOut, _scroller[_axis], resolveScrollerPos (pos), 0.5, true);	}		// TOOLS		private function setConfines ():Void {		_contentTop = _content[_axis];		_gutterTop = _gutter[_axis];		_gutterBot = _gutter[_axis] + _gutter[_prop];		// scale gutter to content mask		_gutter[_prop] = (_isResizeGutter) ? _mask[_prop] : _gutter[_prop];		// set content related confines (isloated since may need to be called on size change)		updateConfines ();	}		private function updateConfines ():Void {		_contentBot = _contentTop + _contentSizeTracker[_prop];		//_contentBot = _content[_axis] + _contentSizeTracker[_prop];		//scale scroller bar in proportion to the content to scroll		if (_isResizeScroller) {			var percent:Number = (_gutterBot - _gutterTop) / (_contentBot - _contentTop);			_scroller[_prop] = constrain (Math.round ((_gutterBot - _gutterTop) * percent), _gutterTop, _gutterBot);			//_scroller[_prop] = Math.round ((_gutterBot - _gutterTop) * percent), _gutterTop, _gutterBot;			//get new gutterBot with new size of scrollerbar                               			_gutterBot = _gutter[_axis] + _gutter[_prop] - _scroller[_prop];		}	}		private function isScrollable ():Boolean {		// check if we need a scroller at all		var _isScrollable:Boolean = (_content[_axis] <= _mask[_axis] && _contentSizeTracker[_prop] < _mask[_prop]) ? false : true;		return _isScrollable;	}		private function resolveScrollerPos (pos:Number) {		//makes sure scroller moves within boundaries		return Math.max (Math.min (pos, _gutterBot), _gutterTop);	}		private function stopScroller () {		_speed = 0;		_slide.stop ();	}		// small utils from elsewhere in com.sekati.* included to keep Scroll portable	private function constrain (val:Number, min:Number, max:Number):Number {		if (val < min) {			val = min;		} else if (val > max) {			val = max;		}		return val;	}		private function setColor (obj:Object, hex:Number):Void {		var c = new Color (obj);		c.setRGB (hex);	}		// MOUSE WHEEL HANDLER		private function setMouseWheel ():Void {		if (_isMouseWheelEnabled) {			//deactivate mousewheel on textfield & activate mouse listener			_content.mouseWheelEnabled = false;			// setup Mac/PC MouseWheel support			MouseWheel.init(_this);		}	}		private function isMouseInArea () {		var x:Number = _content._parent._xmouse;		var y:Number = _content._parent._ymouse;		return (x >= 0 && x <= _mask._width && y >= 0 && y <= _mask[_prop]);	}		private function onMouseWheel (delta:Number) {		if (isMouseInArea () && isScrollable ()) {			var m:Number = _scroller[_axis] - ((_gutter[_prop] / 5) * (delta / 3));			slideScroller (m);		}	}		// UI EVENT HANDLERS		private function scroller_onEnterFrame () {		_scroller._visible = isScrollable ();		// height changed, adjust scroller		if (_contentBot != _contentTop + _contentSizeTracker[_prop]) {			_contentBot = _contentTop + _contentSizeTracker[_prop];			updateConfines ();			_scroller[_axis] = resolveScrollerPos ((_contentTop + _content[_axis]) * (_gutterBot - _gutterTop) / (_gutterBot - _contentBot + _scroller[_prop]) + _gutterTop);			//updateConfines (); // !!! experimental !!! - should update proportional scroller and associated vars		}		//                                                                                                   		if (!_isDragged) {			_oldPos = _scroller[_axis];			_newPos = _oldPos + _speed;			if (_newPos > _gutterBot || _newPos < _gutterTop) {				//bounce - reverse movement				_speed = -_speed;				_newPos = _oldPos;			}			_speed = Math.round (_speed * _friction * 100) / 100;		} else {			_oldPos = _newPos;			_newPos = _scroller[_axis];		}		//update scroller		_scroller[_axis] = _newPos;		//update content		var percent:Number = (_scroller[_axis] - _gutterTop) / (_gutterBot - _gutterTop);		_content[_axis] = Math.round ((percent * (_gutterBot - _contentBot + _scroller[_prop])) + _contentTop);		//weird throw bug fix - gets stuck on speed 0.05 when scroller is thrown upwards and decelerates		if (_speed < 0.1 && _speed > -0.1) {			_speed = 0;		}	}		private function scroller_onRollOver () {		if (!isNaN (_colors.over)) {			setColor (_scroller,_colors.over);		}	}		private function scroller_onRollOut () {		if (!isNaN (_colors.up)) {			setColor (_scroller,_colors.up);		}	}		private function scroller_onPress () {		stopScroller ();		_isDragged = true;		if(_axis == "_y") {			_scroller.startDrag (false, _scroller._x, _gutterTop, _scroller._x, _gutterBot);		} else {			_scroller.startDrag (false, _gutterTop, _scroller._y, _gutterBot, _scroller._y);		}	}		private function scroller_onRelease () {		_scroller.stopDrag ();		_isDragged = false;		//throw		_speed = (_newPos - _oldPos) * _ratio;	}		private function scroller_onReleaseOutside () {		scroller_onRelease ();		scroller_onRollOut ();	}		private function gutter_onPress () {		if (isScrollable ()) {			_gutter.useHandCursor = true;			var mousePos:Number = (_axis == "_y") ? _gutter._parent._ymouse : _gutter._parent._xmouse;			slideScroller (mousePos - (_scroller[_prop] / 2));		} else {			_gutter.useHandCursor = false;		}	}}