/**
 * com.sekati.draw.Line
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Tweenable Line Object
 */
class com.sekati.draw.Line {
	
	private var _mc:MovieClip;
	private var _p1x:Number;
	private var _p1y:Number;
	private var _p2x:Number;
	private var _p2y:Number;
	private var _sw:Number;
	private var _sc:Number;
	private var _sa:Number;
	
	/**
	 * Line Constructor
	 * @param mc (MovieClip)
	 * @param p1x (Number) point 1 x pos
	 * @param p1y (Number) point 1 y pos
	 * @param p2x (Number) point 2 x pos
	 * @param p2y (Number) point 2 y pos
	 * @param strokeWeight (Number) line width [default: 1]
	 * @param strokeColor (Number) line color [default: 0x000000]
	 * @param strokeAlpha (Number) line alpha transparency [default: 100]
	 * @return Void
	 */
	public function Line (mc:MovieClip, p1x:Number, p1y:Number, p2x:Number, p2y:Number, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number) {
		_mc = mc;
		_sw = (!strokeWeight) ? undefined : strokeWeight;
		_sc = (!strokeColor) ? 0x000000 : strokeColor;
		_sa = (!strokeAlpha) ? 100 : strokeAlpha;
		_p1x = p1x;
		_p1y = p1y;
		_p2x = p2x;
		_p2y = p2y;
		draw();
	}
	
	/**
	 * (Re)Draw line with current properties.
	 * @return Void
	 */
	public function draw ():Void {
		_mc.clear();
		_mc.lineStyle (_sw, _sc, _sa, true, "none", "square", "miter", 1.414);
		_mc.moveTo(_p1x, _p1y);
		_mc.lineTo(_p2x, _p2y);
	}
	
	public function get p1x ():Number {
		return _p1x;	
	}
	
	public function set p1x (n:Number):Void {
		_p1x = n;
		draw();
	}	
	
	public function get p1y ():Number {
		return _p1y;	
	}
	
	public function set p1y (n:Number):Void {
		_p1y = n;	
		draw();
	}	
	
	public function get p2x ():Number {
		return _p2x;	
	}

	public function set p2x (n:Number):Void {
		_p2x = n;	
		draw();
	}	

	public function get p2y ():Number {
		return _p2y;	
	}

	public function set p2y (n:Number):Void {
		_p2y = n;	
		draw();
	}	
}