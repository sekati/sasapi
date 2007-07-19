/**
 * com.sekati.display.CoreClip
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.display.ICoreClip;
import com.sekati.core.KeyFactory;
import com.sekati.utils.Delegate;
/**
 * All MovieClip subclasses should extend CoreClip instead of MovieClip for standardized initialization
 */
class com.sekati.display.CoreClip extends MovieClip implements ICoreClip {
	private var _this:MovieClip;
	/**
	 * private constructor as class is initialized via the MovieClip.onLoad event
	 */
	private function CoreClip() {}
	/**
	 * 
	 * @return Void
	 */
	public function onLoad():Void {
		_this = this;
		_this.cacheAsBitmap = true;
		KeyFactory.inject(_this);
		configUI();
	}
	/**
	 * configure UI and initialize behavior - to be overwritten by subclass
	 */
	public function configUI():Void {}
	/**
	 * deconstruct object elements and events for proper garbage collection
	 */
	public function destroy():Void {
		_this.onEnterFrame = null;
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