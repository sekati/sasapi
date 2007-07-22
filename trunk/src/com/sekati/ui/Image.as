﻿/**
 * com.sekati.ui.Image
 * @version 2.5.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.App;
import com.sekati.display.CoreClip;

/**
 * image loader. Required: mc_tween2
 */
class com.sekati.ui.Image extends CoreClip {

	var img:MovieClip;
	var box:MovieClip;
	var spinner:MovieClip;

	// constructor
	private function Image () {
	}

	/**
	 * init called via CoreClip onLoad event
	 * @return Void
	 */
	public function configUI ():Void {
		_this.spinner._visible = false;
	}

	/**
	 * wrapper for setup and init methods
	 * @param uri (String) image uri
	 * @param w (Number) image width
	 * @param h (Number) image height
	 * @param color (Number) box hexadecimal color
	 * @param color2 (Number) spinner & border hexadecimal color	
	 * @param alpha (Number) box alpha
	 * @param border (Boolean) display border
	 * @param cb (Function) optional callback function		
	 * @return Void
	 * 
	 * {@code Usage:
	 * myMc.load("test.jpg", 160, 120, 0x242424, 0x99abc1, 80, true, cb);
	 * }
	 */
	public function load (uri:String, w:Number, h:Number, color:Number, color2:Number, alpha:Number, border:Boolean, cb:Function):Void {
		_this.setup (w, h, color, color2, alpha, border);
		_this.init (uri, cb);
	}

	/**
	 * draw a rectangle (various init options)
	 * @param w (Number) image width
	 * @param h (Number) image height
	 * @param color (Number) box hexadecimal color
	 * @param color2 (Number) spinner & border hexadecimal color	
	 * @param alpha (Number) box alpha
	 * @param border (Boolean) display border
	 * @return Void
	 * 
	 * {@code Usage:
	 * myMc.setup(160, 120, 0x242424, 0x99abc1, 80, true);
	 * }
	 */
	public function setup (w:Number, h:Number, color:Number, color2:Number, alpha:Number, border:Boolean):Void {
		// make instance reusable
		if (_this.box != undefined) {
			_this.box.removeMovieClip ();
		}
		if (_this.img != undefined) {
			_this.img.removeMovieClip ();
		}
		var img:MovieClip = _this.createEmptyMovieClip ("img", _this.getNextHighestDepth ());
		// create box & enable spinner if a box color was passed
		if (color) {
			_this.createEmptyMovieClip ("box", _this.getNextHighestDepth ());
			var c:Number = (color) ? color : 0xFFFFFF;
			var a:Number = (alpha) ? alpha : 100;
			var lw:Number = (border) ? 1 : 0;
			var c2:Number = (color2) ? color2 : 0x000000;
			// offset for 1px border
			if (lw == 1) {
				w += lw;
				h += lw;
				_this.img._x += lw;
				_this.img._y += lw;
			}
			if (border) {
				box.lineStyle (lw, c2, a);
			}
			box.beginFill (c, a);
			box.moveTo (0, 0);
			box.lineTo (w, 0);
			box.lineTo (w, h);
			box.lineTo (0, h);
			box.endFill ();
		}
		// setup spinner                                                           
		_this.spinner._x = int ((w / 2));
		_this.spinner._y = int ((h / 2));
		_this.spinner.colorTo (c2, 0);
	}
	
	/**
	 * load an image after setup has been called
	 * @param uri (String) image uri
	 * @param cb (Function) optional callback function
	 * @return Void
	 * 
	 * {@code Usage:
	 * myMc.init ("test.jpg", cb);
	 * }
	 */
	public function init (uri:String, cb:Function):Void {
		_this.img.unloadMovie ();
		_this.img._alpha = 0;
		_this.img.swapDepths (_this.getNextHighestDepth ());
		_this.spinner.swapDepths (_this.getNextHighestDepth ());
		_this.img.loadMovie (uri);
		_this.spinner._visible = true;
		_this.spinner._alpha = 100;
		delete _this.spinner.onEnterFrame;
		_this.spinner.onEnterFrame = function () {
			this._rotation -= 20;
		};
		_this.onEnterFrame = function () {
			var l:Number = _this.img.getBytesLoaded ();
			var t:Number = _this.img.getBytesTotal ();
			if (l >= t && t > 5) {
				delete _this.onEnterFrame;
				_this.img.stopTween ();
				_this.spinner.stopTween ();
				_this.img._alpha = 0;
				_this.spinner._alpha = 100;
				_this.img.alphaTo (100, 0.6, App.mot.e, 0.1);
				var spinCb = function () {
					delete _this.spinner.onEnterFrame;
					_this.spinner._visible = false;
					_this.spinner._alpha = 100;
				};
				_this.spinner.alphaTo (0, 0.5, App.mot.e, 0.3, spinCb);
				if (cb) {
					cb ();
				}
			}
		};
	}
}