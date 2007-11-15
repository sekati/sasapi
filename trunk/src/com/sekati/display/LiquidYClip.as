/**
 * com.sekati.display.LiquidYClip
 * @version 1.0.3
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.LiquidClip;
 import com.sekati.math.MathBase;

/**
 * LiquidYClip
 */
class com.sekati.display.LiquidYClip extends LiquidClip {
	
	private var _yoffset:Number;
	private var _ymin:Number;
	
	public function LiquidYClip() {
		super();
		_yoffset = 0;
		_ymin = 0;
	}
	
	private function _onResize():Void {
		_this._y = MathBase.constrain(int(Stage.height - _this._height - _yoffset), _ymin - _this._height, Stage.height);
	}	

}