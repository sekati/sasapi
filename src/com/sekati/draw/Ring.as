/**
 * com.sekati.draw.Ring
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.geom.Point;
 
/**
 * Ring drawing utility.
 */
class com.sekati.draw.Ring {
	
	/**
	 * Draw a Ring in an existing clip.
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param p (Point) center point
	 * @param outerRadius (Number) radius of outer circle
	 * @param innerRadius (Number) radius of inner (cut out) circle
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param fillAlpha (Number) fill alpha transparency [default: 100]
	 * @param strokeWeight (Number) border line width, if 0 or undefined no border will be drawn
	 * @param strokeColor (Number) hex border color 
	 * @param strokeAlpha (Number) stroke alpha transparancy [default: 100]
	 * @return Void
	 */
	public static function draw (mc:MovieClip, p:Point, outerRadius:Number, innerRadius:Number, fillColor:Number, fillAlpha:Number, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number):Void {
		var sw:Number = (!strokeWeight) ? undefined : strokeWeight;
		var sc:Number = (!strokeColor) ? 0x000000 : strokeColor;
		var fa:Number = (!fillAlpha) ? 100 : fillAlpha;
		var sa:Number = (!strokeAlpha) ? 100 : strokeAlpha;
		
		var x:Number = p.x;
		var y:Number = p.y;
		var r1:Number = outerRadius;
		var r2:Number = innerRadius;
		var TO_RADIANS:Number = Math.PI/180;
		
		mc.clear();
		mc.lineStyle(strokeWeight, strokeColor, strokeAlpha, true, "none", "round", "round", 8);
		if (fillColor) {
			mc.beginFill(fillColor, fillAlpha);
		}		
		
		mc.moveTo(0,0);
		mc.lineTo(r1,0);

		// draw the 30-degree segments
		var a:Number = 0.268;  // tan(15)
		for (var i=0; i < 12; i++) {
			var endx:Number = r1*Math.cos((i+1)*30*TO_RADIANS);
			var endy:Number = r1*Math.sin((i+1)*30*TO_RADIANS);
			var ax:Number = endx+r1*a*Math.cos(((i+1)*30-90)*TO_RADIANS);
			var ay:Number = endy+r1*a*Math.sin(((i+1)*30-90)*TO_RADIANS);
			mc.curveTo(ax, ay, endx, endy);   
	   }		
		
 		// cut out middle (go in reverse)
		mc.moveTo(0, 0);
 		mc.lineTo(r2, 0);		

		for (var i=12; i > 0; i--) {
			var endx = r2*Math.cos((i-1)*30*TO_RADIANS);
			var endy = r2*Math.sin((i-1)*30*TO_RADIANS);
			var ax = endx+r2*(0-a)*Math.cos(((i-1)*30-90)*TO_RADIANS);
			var ay = endy+r2*(0-a)*Math.sin(((i-1)*30-90)*TO_RADIANS);
			mc.curveTo(ax, ay, endx, endy);   
		}
		if (fillColor) {
			mc.endFill();
		}		
 		mc._x = x;
		mc._y = y;		
	}

/*
// r1 = radius of outer circle
// r2 = radius of inner circle (cutout)
// x, y = center of donut
MovieClip.prototype.drawDonut = function (r1, r2, x, y) {
   var TO_RADIANS:Number = Math.PI/180;
   this.moveTo(0, 0);
   this.lineTo(r1, 0);

   // draw the 30-degree segments
   var a:Number = 0.268;  // tan(15)
   for (var i=0; i < 12; i++) {
      var endx = r1*Math.cos((i+1)*30*TO_RADIANS);
      var endy = r1*Math.sin((i+1)*30*TO_RADIANS);
      var ax = endx+r1*a*Math.cos(((i+1)*30-90)*TO_RADIANS);
      var ay = endy+r1*a*Math.sin(((i+1)*30-90)*TO_RADIANS);
      this.curveTo(ax, ay, endx, endy);   
   }
 
   // cut out middle (go in reverse)
   this.moveTo(0, 0);
   this.lineTo(r2, 0);

   for (var i=12; i > 0; i--) {
      var endx = r2*Math.cos((i-1)*30*TO_RADIANS);
      var endy = r2*Math.sin((i-1)*30*TO_RADIANS);
      var ax = endx+r2*(0-a)*Math.cos(((i-1)*30-90)*TO_RADIANS);
      var ay = endy+r2*(0-a)*Math.sin(((i-1)*30-90)*TO_RADIANS);
      this.curveTo(ax, ay, endx, endy);   
   }
 
   this._x = x;
   this._y = y;
}

// example usage:
createEmptyMovieClip("d", 1);
d.beginFill(0xaa0000, 60);
d.drawDonut(100, 50, 200, 200);
d.endFill();

*/	
	
	
	private function Ring(){
	}
}