/**
 * com.sekati.display.BaseClip
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.KeyFactory;
 import com.sekati.utils.MovieClipUtils;
 
/**
 * This is the foundational MovieClip class and should be
 * thought of as the main building block of the SASAPI framework.
 * @see {@link com.sekati.display.CoreClip}
 */
class com.sekati.display.BaseClip extends MovieClip {
	
	private var _this:MovieClip;
	
	public function BaseClip() {
		_this = this;
		KeyFactory.inject(_this);
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
}