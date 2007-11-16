/**
 * com.sekati.display.EventClip
 * @version 1.0.3
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.CoreClip;
 import com.sekati.events.Broadcaster;

/**
 * Event driven core Clip - recieves {@link com.sekati.events.Broadcaster} events.
 */
class com.sekati.display.EventClip extends CoreClip {
	
	/**
	 * Constructor
	 */
	public function EventClip() {
		super();
		Broadcaster.$.subscribe(_this);
	}
	
	/**
	 * Remove from Event Dispatchers and Broadcasters onUnload.
	 * @return Void
	 */
	public function onUnload():Void {
		super.onUnload();
		Broadcaster.$.unsubscribe(_this);
	}

}