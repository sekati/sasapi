/**
 * com.sekati.display.CoreClip
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.display.ICoreClip;
import com.sekati.core.KeyFactory;
import com.sekati.utils.MovieClipUtils;
/**
 * Base class mix-in that all MovieClip UI subclasses should extend
 * instead of MovieClip for standardized initialization & deconstruction.
 * @see {@link com.sekati.display.AbstractClip}
 */
class com.sekati.display.CoreClip extends MovieClip implements ICoreClip {
	private var _this:MovieClip;
	/**
	 * private constructor; class is initialized via the MovieClip.onLoad event.
	 */
	private function CoreClip() {}
	/**
	 * onLoad does core setup when clip registers on stage via onLoad. 
	 * Do not override this in subclasses; instead override configUI.
	 * @return Void
	 */
	public function onLoad():Void {
		_this = this;
		_this.cacheAsBitmap = true;
		KeyFactory.inject(_this);
		configUI();
	}
	/**
	 * Configure UI and initialize behavior; should be overwritten by subclasses.
	 */
	public function configUI():Void {}
	/**
	 * Destroy object elements and events for proper garbage collection.
	 * This is a generic destroy method to insure that, at a minimum, the 
	 * enterFrame and clip itself are removed when destroy is called. 
	 * This behavior can be overwritten by CoreClip's subclasses. 
	 * If you wish to use CoreClip's destroy in addition to your subclass 
	 * destroy you may do so via: 
	 * {@code 
	 * 	super.destroy(); 
	 * }
	 */
	public function destroy():Void {
		_this.onEnterFrame = null;
		MovieClipUtils.rmClip(_this);
	}
	/**
	 * give verbose trace output
	 * @return String
	 */
	public function toString():String {
		var str:String = _this._name + "= { \n";
		for (var i in _this) {
			str += "\t" + i + ": " + _this[i].toString() + "\n";
		}
		str += "};";
		return str;
	}
	//
}
// eof