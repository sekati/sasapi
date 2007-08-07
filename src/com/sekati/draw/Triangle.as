/**
 * com.sekati.draw.Triangle
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.geom.Point;
 
/**
 * Triangle drawing utilities.
 */
class com.sekati.draw.Triangle {
	
	/**
	 * Draw a triangle in an existing clip
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param p1 (Point) first point
	 * @param p2 (Point) second point
	 * @param p3 (Point) third point
	 * @param strokeWeight (Number) border line width, if undefined no border will be drawn
	 * @param borderColor (Number) hex border color 
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param alpha (Number) rectangle alpha value (border & fill)
	 * @return Void
	 * {@code Usage:
	 * 	var tri:MovieClip = this.createEmptyMovieClip ("tri", this.getNextHighestDepth ());
	 * 	Triangle.draw(tri, new Point(0,30), new Point(30,30), new Point(30,0), 1, 0xff00ff, 0xffff00, 100);
	 * }
	 */
	public static function draw (mc:MovieClip, p1:Point, p2:Point, p3:Point, strokeWeight:Number, borderColor:Number, fillColor:Number, alpha:Number):Void {
		var l:Number = (!strokeWeight) ? undefined : strokeWeight;
		var b:Number = (!borderColor) ? 0x000000 : borderColor;
		var a:Number = (!alpha) ? 100 : alpha;
		mc.clear();
		mc.lineStyle (l, b, a, true, "none", "square", "miter", 1.414);
		if (fillColor) {
			mc.beginFill (fillColor, a);
		}
		mc.moveTo(p1.x, p1.y);
		mc.lineTo(p2.x, p2.y);
		mc.lineTo(p3.x, p3.y);
		mc.lineTo(p1.x, p1.y);
		if (fillColor) {
			mc.endFill ();
		}
	}
	
	private function Triangle(){
	}
}