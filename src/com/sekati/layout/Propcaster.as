/**
 * com.sekati.layout.Propcaster
 * @version 1.0.2
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.CoreObject;
 import com.sekati.draw.Rectangle;
 import com.sekati.display.StageDisplay;
 import com.sekati.events.Broadcaster;
 import com.sekati.events.Dispatcher;
 import com.sekati.geom.Point;
 import com.sekati.utils.ClassUtils;
 import com.sekati.utils.AlignUtils;
 import com.sekati.utils.Delegate;

/**
 * Propcaster singleton creates a baseclip rectangle on stage which is used to track and broadcast
 * a content viewport scaled proportionally to the Stage. 
 * 
 * This wraps and simplifies the {@link com.sekati.display.StageDisplay} dispatched events and 
 * pushes them thru {@link com.sekati.events.Broadcaster} using the {@code onPropcast} event after 
 * updating the tracking clip so that the information may be used in liquid layouts that require 
 * positional relationships.
 */
class com.sekati.layout.Propcaster extends CoreObject {

	private static var _instance:Propcaster;
	private static var _proportionW:Number = 16;
	private static var _proportionH:Number = 9;
	
	private var _this:Propcaster;
	private var _tracker:MovieClip;

	/**
	 * Singleton Constructor - create a tracker clip, set to proper ratio and listen for stage events.
	 */
	private function Propcaster() {
		super();
		trace("*** - Proportioncaster Initialized ...");
		_this = this;
		_tracker = ClassUtils.createEmptyMovieClip(com.sekati.display.BaseClip, _root, "__prop_track_rect__", {_x:0, _y:0, _alpha:10, _visible:true});
		Rectangle.draw(_tracker, new Point(0,0), new Point(_proportionW, _proportionH), 0xFF00FF, 100, 0);
		Dispatcher.$.addEventListener(StageDisplay.onStageResizeEVENT, Delegate.create (_this, update));
		update();
	}

	/**
	 * Singleton Accessor
	 * @return Proportioncaster
	 */
	public static function getInstance():Propcaster {
		if (!_instance) _instance = new Propcaster();
		return _instance;
	}

	/**
	 * shorthand singleton accessor getter
	 */
	 public static function get $():Propcaster {
	 	return Propcaster.getInstance();	
	 }
	
	/**
	 * Set a new proportion to scale by.
	 * @param w (Number)
	 * @param h (Number)
	 * @return Void
	 */
	public function setProp(w:Number, h:Number):Void {
		_proportionW = w;
		_proportionH = h;
		update();
	}

	/**
	 * Proportionally scale the tracker to fit Stage.
	 * @return Void
	 */
	private function update():Void {
		AlignUtils.scaleRatio (_tracker, Stage.width, Stage.height);
		AlignUtils.alignCenter (_tracker, StageDisplay.$);
		Broadcaster.$.broadcast("onPropcast", p);
	}
	
	/**
	 * _x getter
	 * @return Number
	 */
	public function get x():Number {
		return _tracker._x;	
	}

	/**
	 * _y getter
	 * @return Number
	 */
	public function get y():Number {
		return _tracker._y;	
	}
	
	/**
	 * _width getter
	 * @return Number
	 */	
	public function get w():Number {
		return _tracker._width;	
	}

	/**
	 * _height getter
	 * @return Number
	 */	
	public function get h():Number {
		return _tracker._height;
	}

	/**
	 * return bottom of "viewport"
	 * @return Number
	 */
	public function get bottom():Number {
		return y+h;	
	}

	/**
	 * proportion getter
	 * @return Object
	 */
	public function get p():Object {
		return {x:x, y:y, w:w, h:h, b:bottom};
	}
}
