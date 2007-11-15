/**
 * com.sekati.display.LiquidWClip
 * @version 1.0.1
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.LiquidClip;

/**
 * LiquidWClip 
 */
class com.sekati.display.LiquidWClip extends LiquidClip {
	
	public function LiquidWClip() {
		super();
	}
	
	public function _onResize():Void {
		_this._width = Stage.width;
	}	

}