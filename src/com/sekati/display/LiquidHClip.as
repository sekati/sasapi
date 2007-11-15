/**
 * com.sekati.display.LiquidHClip
 * @version 1.0.1
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.LiquidClip;

/**
 * LiquidHClip 
 */
class com.sekati.display.LiquidHClip extends LiquidClip {
	
	public function LiquidHClip() {
		super();
	}
	
	public function _onResize():Void {
		_this._height = Stage.height;
	}	

}