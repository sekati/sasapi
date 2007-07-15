/**
 * com.sekati.display.AbstractClip
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.display.CoreClip;
/**
 * Generic subclass implementation of CoreClip and CoreClipInterface
 * To be used as template for all framework based extend movieclip classes
 */
class com.sekati.display.AbstractClip extends CoreClip {
	/**
	 * Constructor - always empty - use init
	 */
	private function AbstractClip() {
	}
	/**
	 * overrides CoreClip init with behaviors once clip is loaded/registered on stage
	 */
	private function configUI():Void {
		_this.test();
	}
	private function test():Void {
		trace("AbstractClip subclass instance: "+_this._name);
		trace(_this);
	}
}