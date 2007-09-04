/**
 * com.sekati.display.CoreClip
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

 import com.sekati.display.BaseClip;
 import com.sekati.display.ICoreClip;

/**
 * Core UI mix-in that all interface subclasses should extend 
 * instead of MovieClip for standardized UI initialization.
 * @see {@link com.sekati.display.AbstractClip}
 */
class com.sekati.display.CoreClip extends BaseClip implements ICoreClip {

	/**
	 * private constructor; class is initialized via the MovieClip.onLoad event.
	 */
	private function CoreClip() {
	}

	/**
	 * onLoad does core setup when clip registers on stage via onLoad. 
	 * Do not override this in subclasses; instead override configUI.
	 * @return Void
	 */
	public function onLoad():Void {
		_this.cacheAsBitmap = true;
		configUI();
	}

	/**
	 * Configure UI and initialize behavior; should be overwritten by subclasses.
	 */
	public function configUI():Void {
	}
}