/**
 * com.sekati.display.CoreClip
 * @version 1.0.9
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

 import com.sekati.display.BaseClip;
 import com.sekati.display.ICoreClip;

/**
 * Core UI mixin that all interface subclasses should extend 
 * instead of MovieClip for standardized UI initialization.<br><br>
 * 
 * Note: CoreClip should only be used for classes which will
 * extend library clips via linkage id. If you are using 
 * {@link com.sekati.utils.ClassUtils} to extend a class use
 * {@link com.sekati.display.BaseClip} as the onLoad event
 * will have fired before the clip is extended.
 * 
 * @see {@link com.sekati.display.AbstractClip}
 */
class com.sekati.display.CoreClip extends BaseClip implements ICoreClip {

	/**
	 * Private Constructor; class is initialized via the MovieClip.onLoad event.
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