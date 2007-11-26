/**
 * com.sekati.display.BaseClip
 * @version 1.0.6
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.IBaseClip;
 import com.sekati.display.ITweenClip;
 import com.sekati.core.KeyFactory;
 import com.sekati.reflect.Stringifier;
 import com.sekati.transitions.Tweener;
 import com.sekati.utils.MovieClipUtils;
 
/**
 * This is the foundational MovieClip class and should be
 * thought of as the main building block of the SASAPI framework.
 * @see {@link com.sekati.display.CoreClip}
 */
class com.sekati.display.BaseClip extends MovieClip implements IBaseClip, ITweenClip {

	private var _this:MovieClip;
	private var __isClean:Boolean;
	
	public function BaseClip() {
		_this = this;
		__isClean = false;
		KeyFactory.inject(_this);
	}

	/**
	 * if destroy hasnt already been called manually
	 * run it onUnload.
	 */
	public function onUnload():Void {
		if(!__isClean) {
			destroy();
		}	
	}
	
	/**
	 * Destroy object elements and events for proper garbage collection.
	 * This is a generic destroy method to insure that, at a minimum, the 
	 * enterFrame and clip itself are removed when destroy is called. 
	 * This behavior can be overwritten by BaseClip's subclasses. 
	 * If you wish to use BaseClip's destroy in addition to your subclass 
	 * destroy you may do so via: 
	 * {@code
	 * 	super.destroy(); 
	 * }
	 */	
	public function destroy():Void {
		__isClean = true;
		_this.onEnterFrame = null;
		for(var i in _this) {
			MovieClipUtils.rmClip(_this[i]);	
		}
		MovieClipUtils.rmClip(_this);		
	}
	
	/**
	 * A very basic wrapper to apply a tween to the current object via {@link com.sekati.transitions.Tweener.addTween}
	 * @see {@link http://hosted.zeh.com.br/tweener/docs/en-us/}
	 * @param tweenerObject (Object)
	 * @return Void
	 */
	public function tween (tweenerObject:Object):Void {
		Tweener.addTween (_this, tweenerObject);
	}
	
	/**
	 * Remove any or all Tweener tweens using arguments array.
	 * @param arguments
	 * @return Void 
	 */
	public function stopTween():Void {
		Tweener.removeTweens(_this, arguments);
	}

	/**
	 * return reflective output
	 * @return String
	 */	
	public function toString():String {
		return Stringifier.stringify(this);
	}
}