/**
 * com.sekati.display.StageDisplay
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

 import com.sekati.core.CoreObject;
 import com.sekati.events.Dispatcher;
 import com.sekati.events.Event;
 import com.sekati.events.FramePulse;
 import com.sekati.geom.Point;
 import com.sekati.utils.Delegate;
 
/**
 * StageDisplay eases Stage interfacing with added/simplified methods and properties. 
 * Note {@link _fullscreen()} requires Flash Player >=9.0.28
 */
class com.sekati.display.StageDisplay extends CoreObject {
	
	private static var _instance:StageDisplay;
	private static var onStageResizeEVENT:String = "onStageResize";
	private static var onStageFullscreenEVENT:String = "onStageFullscreen";
	private static var onStageReadyEVENT:String = "onStageReady";
	
	/**
	 * Singleton Private Constructor
	 */
	 private function StageDisplay () {
		super();
		Stage.addListener (this);
		FramePulse.$.addFrameListener(this);
	}
	
	/**
	 * Singleton Accessor
	 * @return StageDisplay
	 */
	public static function getInstance ():StageDisplay {
		if (!_instance) {
			_instance = new StageDisplay ();
		}
		return _instance;
	}

	/**
	 * Shorthand singleton accessor getter
	 * @return StageDisplay
	 */
	public static function get $():StageDisplay {
	 	return StageDisplay.getInstance();	
	}
	
	/**
	 * Stage.onResize dispatches onStageResize event.
	 * @return Void 
	 */ 
	public function onResize():Void {
		Dispatcher.$.dispatchEvent(new Event(onStageResizeEVENT,_instance,{_width:_width, _height:_height}));	
	}
	
	/**
	 * Stage.onFullScreen dispatches onStageFullscreen event.
	 * @return Void
	 */
	public function onFullScreen(bFull:Boolean):Void {
		Dispatcher.$.dispatchEvent(new Event(onStageFullscreenEVENT,_instance,{isFullscreen:bFull}));
	}
	
	/**
	 * Listen to {@link com.sekati.events.FramePulse} and dispatch an onStageReadyEVENT once the Stage has initialized.
	 * @return Void
	 */
	private function _onEnterFrame():Void {
		if (isReady){
			FramePulse.$.removeFrameListener(this);
			Dispatcher.$.dispatchEvent(new Event(onStageReadyEVENT,_instance,{isReady:isReady}));	
		}
	}	
	
	/**
	 * StageDisplay.isReady getter to indicate if Stage has been fully initialized.
	 * @return Boolean 
	 */
	public function get isReady():Boolean {
		return (_width > 0 && _height > 0);	
	}
	
	/**
	 * Stage.width getter.
	 * @return Number
	 */
	public function get _width():Number {
		return Stage.width;	
	}

	/**
	 * Stage.height getter.
	 * @return Number
	 */
	public function get _height():Number {
		return Stage.height;
	}
	
	/**
	 * Stage size getter.
	 * @return Point - containing right, bottom.
	 */
	public function get _size():Point {
		return new Point(_width, _height);	
	}
	
	/**
	 * Stage center _x getter.
	 * @return Number
	 */
	public function get _centerx():Number {
		return Math.round(_width / 2);
	}

	/**
	 * Stage center _y getter.
	 * @return Number
	 */
	public function get _centery():Number {
		return Math.round(_height / 2);
	}
	
	/**
	 * Stage center getter.
	 * @return Point
	 */
	public function get _center():Point {
		return new Point(_centerx, _centery);	
	}

	/**
	 * Stage.displayState fullscreen getter
	 * @return Boolean - true if fullscreen, false if normal.
	 */	 
	public function get _fullscreen():Boolean {
	 	return (Stage["displayState"] == "fullScreen") ? true : false;
	}
	
	/**
	 * Stage.displayState fullscreen setter - dispatches "onStageFullscreen" event.
	 * @param b (Boolean) true sets fullscreen, false sets normal.
	 */
	public function set _fullscreen(b:Boolean):Void {
		var state:String = (!b) ? "normal" : "fullScreen";
	 	Stage["displayState"] = state;
	}
	
	/**
	 * toggle Stage.displayState between "normal" and "fullScreen".
	 * @return Void
	 */
	public function toggleFullscreen():Void {	
		_fullscreen = !_fullscreen;
	}
	
	/**
	 * Destroy Singleton instance.
	 * @return Void
	 */
	public function destroy():Void {
		FramePulse.$.removeFrameListener(this);
		super.destroy();	
	}
}