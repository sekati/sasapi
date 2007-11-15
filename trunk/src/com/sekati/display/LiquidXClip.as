/**
 * com.sekati.display.LiquidXClip
 * @version 1.0.3
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.LiquidClip;
 import com.sekati.math.MathBase;

/**
 * LiquidXClip
 */
class com.sekati.display.LiquidXClip extends LiquidClip {
	
	private var _xoffset:Number;
	private var _xmin:Number;
	
	public function LiquidXClip() {
		super();
		_xoffset = 0;
		_xmin = 0;
	}
	
	private function _onResize():Void {
		_this._x = MathBase.constrain(int(Stage.width - _this._width - _xoffset), _xmin, Stage.width);
	}

}