/**
 * com.sekati.draw.Rectangle
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * 
 */
class com.sekati.draw.Rectangle {
	
	public static function draw (target:MovieClip, rName:String, w:Number, h:Number, color:Number, alpha:Number, lineWeight:Number, lineColor:Number):MovieClip {
		var mc:MovieClip = target.createEmptyMovieClip (rName, target.getNextHighestDepth ());
		var c:Number = (color) ? color : 0xFFFFFF;
		var a:Number = (alpha) ? alpha : 100;
		var lw:Number = (lineWeight) ? lineWeight : 0;
		var lc:Number = (lineColor) ? lineColor : 0x000000;
		mc.lineStyle (lw, lc, a);
		mc.beginFill (c, a);
		mc.moveTo (0, 0);
		mc.lineTo (w, 0);
		mc.lineTo (w, h);
		mc.lineTo (0, h);
		mc.endFill ();
		return mc;
	}
	
	private function Rectangle(){}
}