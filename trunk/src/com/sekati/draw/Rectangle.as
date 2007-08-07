/**
 * com.sekati.draw.Rectangle
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.KeyFactory;
 
/**
 * Rectangle drawing utilities.
 */
class com.sekati.draw.Rectangle {

	/**
	 * Draw a rectangle in an existing clip
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param x (Number) x position [default: 0]
	 * @param y (Number) y position [default: 0]
	 * @param w (Number) width
	 * @param h (Number) height
	 * @param strokeWeight (Number) border line width, if undefined no border will be drawn
	 * @param borderColor (Number) hex border color 
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param alpha (Number) rectangle alpha value (border & fill)
	 * @return Void
	 * {@code Usage:
	 * 	var box:MovieClip = this.createEmptyMovieClip ("box", this.getNextHighestDepth ());
	 * 	Rectangle.draw(box, 50, 50, 100, 100, 1, 0xff00ff, 0xffff00, 100);
	 * }
	 */
	public static function draw (mc:MovieClip, x:Number, y:Number, w:Number, h:Number, strokeWeight:Number, borderColor:Number, fillColor:Number, alpha:Number):Void {
		var l:Number = (!strokeWeight) ? undefined : strokeWeight;
		var b:Number = (!borderColor) ? 0x000000 : borderColor;
		var a:Number = (!alpha) ? 100 : alpha;
		var tl:Number = (!x) ? 0 : x;
		var bl:Number = (!y) ? 0 : y;
		var tr:Number = x+w;
		var br:Number = y+h;
		mc.clear();
		mc.lineStyle (l, b, a, true, "none", "square", "miter", 1.414);
		if (fillColor) {
			mc.beginFill (fillColor, a);
		}
		mc.moveTo (tl,bl);
		mc.lineTo (tr,bl);
		mc.lineTo (tr,br);
		mc.lineTo (tl,br);
		if (fillColor) {
			mc.endFill ();
		}
	}
	
	public static function drawRound (mc:MovieClip, x:Number, y:Number, w:Number, h:Number, cornerRadius:Number, borderColor:Number, fillColor:Number, alpha:Number):Void {
		var l:Number = (!borderColor) ? undefined : 1;
		var b:Number = (!borderColor) ? 0x000000 : borderColor;
		var a:Number = (!alpha) ? 100 : alpha;
		mc.clear();
				
	}
	
	private function Rectangle(){
	}
}