﻿/** * com.sekati.draw.DrawUtils * @version 2.0.1 * @author jason m horwitz | sekati.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ /** * static class wrapper for various drawing and shape utilities */class com.sekati.draw.DrawUtils {
	/**	 * draw a rectangle (various init options)	 * @param target (MovieClip) target scope  to create MovieClip within	 * @param rName (String) name of rectangle mc to be created	 * @param w (Number) rectangle width	 * @param h (Number) rectangle height	 * @param color (Number) rectangle hexadecimal color	 * @param alpha (Number) rectangle alpha	 * @param lineWeight (Number) rectangle line width	 * @param lineColor (Number) rectangle line hexadecimal color	 * @return Void	 * 	 * {@code Usage:	 * DrawUtils.drawRect (_root, "box", 320, 240, 0xff00ff, 75, 1, 0xffeeff);	 * }	 */	public static function drawRect(target:MovieClip, rName:String, w:Number, h:Number, color:Number, alpha:Number, lineWeight:Number, lineColor:Number):Void {		var mc:MovieClip = target.createEmptyMovieClip( rName, target.getNextHighestDepth( ) );		var c:Number = (color) ? color : 0xFFFFFF;		var a:Number = (alpha) ? alpha : 100;		var lw:Number = (lineWeight) ? lineWeight : 0;		var lc:Number = (lineColor) ? lineColor : 0xFF00FF;		mc.lineStyle( lw, lc, a );		mc.beginFill( c, a );		mc.moveTo( 0, 0 );		mc.lineTo( w, 0 );		mc.lineTo( w, h );		mc.lineTo( 0, h );		mc.endFill( );	}
	private function DrawUtils() {	}}