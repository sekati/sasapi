/**
 * com.sekati.utils.MiscUtils
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Miscellaneous utilities - to be sorted
 */
class com.sekati.utils.MiscUtils {

	/**
	 * javascript resize window
	 */
	public static function jsResizeWin(w:Number, h:Number):Void {
		getURL ("javascript:top.resizeTo(" + w + "," + h + ")");
	}

	/**
	 * javascript shake window
	 */
	public static function jsShakeWin (amount:Number):Void {
		getURL ("javascript:function shakewin(n){if(parent.moveBy){for(i = 10;i > 0;i--){for(j = n;j > 0;j--){parent.moveBy(0,i);parent.moveBy(i,0);parent.moveBy(0,-i);parent.moveBy(-i,0);}}}};shakewin(" + amount + ");void(0)");
	}

	/**
	 * javascript change status message
	 */
	public static function jsStatus(msg:String):Void {
		getURL ("javascript:if(typeof(this.href) != 'undefined') window.status = '" + msg + "' + ' URL: ' + this.href;else return false;void(0)");
	}

	/**
	 * javascript pop centered window
	 */
	public static function jsCenterWin (wURL:String, wName:String, w:Number, h:Number, scr:Boolean):Void {
		var cx:Number = Math.round ((System.capabilities.screenResolutionX / 2) - (w / 2));
		var cy:Number = Math.round ((System.capabilities.screenResolutionY / 2) - (h / 2));
		getURL ("javascript:NewWindow=window.open('" + wURL + "','" + wName + "','width=" + w + ",height=" + h + ",left=" + cx + ",top=" + cy + ",screenX=" + cx + ",screenY=" + cy + ",toolbar=no,location=no,scrolling=" + scr + ",directories=no,scrollbars=" + scr + ",status=no,statusbar=no,resizable=no,fullscreen=no'); NewWindow.focus(); void(0);");
	}

	/**
	 * javascript pop centered window with single string param - needs revision
	 */
	public static function centerPop(x:String):Void {
		trace ("__________centerPop");
		var a:Array = x.split ("|");
		var wURL:String = a[0];
		var wName:String = a[1];
		var w:Number = a[2];
		var h:Number = a[3];
		var scr:Boolean = a[4];
		var centerx:Number = Math.round ((System.capabilities.screenResolutionX / 2) - (w / 2));
		var centery:Number = Math.round ((System.capabilities.screenResolutionY / 2) - (h / 2));
		getURL ("javascript:NewWindow=window.open('" + wURL + "','" + wName + "','width=" + w + ",height=" + h + ",left=" + centerx + ",top=" + centery + ",screenX=" + centerx + ",screenY=" + centery + ",toolbar=no,location=no,scrolling=" + scr + ",directories=no,scrollbars=" + scr + ",status=no,statusbar=no,resizable=no,fullscreen=no'); NewWindow.focus(); void(0);");
	}

	/**
	 * play a sound linked from library.
	 * Deprecated: Please see com.sekati.managers.SoundManager
	 * @param s (String) sound linkage id
	 * @param v (Number) volume [0 - 100]
	 * @param p (Number) pan [-100 - 100]
	 */
	public static function sound(s:String, v:Number, p:Number){
		var snd = new Sound ();
		snd.attachSound (s);
		if (v == undefined) {
			snd.setVolume (100);
		} else {
			snd.setVolume (v);
		}
		if (p != undefined) {
			snd.setPan (p);
		}
		snd.start (0, 0);
	}

	/**
	 * pan sound to stage pos - requires revision
	 */
	public static function panSound(s:String, v:Number, x:Number, y:Number):Void  {
		var snd = new Sound ();
		snd.attachSound (s);
		if (x > Stage.width / 2) {
			var p = Math.round (x * 100 / Stage.width);
		} else {
			var p = Math.round ((x - Stage.width) * 100 / (Stage.width / 2)) + 100;
		}
		var vp = 100 - (Math.round (y * 100 / Stage.height));
		// v percent
		var vl = Math.round (v / 100 * vp);
		// actual v 
		if (vl < 0) {
			if (v > 0) {
				vl = 5;
			} else {
				vl = 0;
			}
		}
		snd.setVolume (vl);
		snd.setPan (p);
		snd.start (0, 0);
	}

	/**
	 * convert fahrenheit to celsius
	 * @param f (Number) fahrenheit value
	 * @param p (Number) number of decimal after int '.' without round
	 * @return Number
	 */
	public static function f2c(f:Number, p:Number):Number {
		var d;
		var r = (5 / 9) * (f - 32);
		var s = r.toString ().split (".");
		if (s[1] != undefined) {
			d = s[1].substr (0, p);
		} else {
			var i = p;
			while (i > 0) {
				d += "0";
				i--;
			}
		}
		var c = s[0] + "." + d;
		return Number (c);		
	}

	/**
	 * convert celsius to fahrenheit
	 * @param c (Number) celsius value
	 * @param p (Number) number of decimal after int '.' without round
	 * @return Number
	 */
	public static function c2f(c:Number, p:Number):Number {
		var d;
		var r = (c / (5 / 9)) + 32;
		var s = r.toString ().split (".");
		if (s[1] != undefined) {
			d = s[1].substr (0, p);
		} else {
			var i = p;
			while (i > 0) {
				d += "0";
				i--;
			}
		}
		var f = s[0] + "." + d;
		return Number (f);		
	}

	/* more to be converted
		// global menu Delay (pause momentarily before initalizing to give some switch time for user)
		_global.menuDelay = function (sec:Number, cb:Function):Void  {
			var di = $menuDelayInt, fireTime = getTimer () + (sec * 1000);
			if (di || _global.countMenuInt) {
				clearInterval (di);
				delete _global.countMenuInt;
			}
			_global.countMenuInt = function () {
				if (fireTime <= getTimer ()) {
					clearInterval (di);
					delete _global.countMenuInt;
					cb ();
				}
			};
			di = setInterval (this, "countMenuInt", 500);
		};
		
		 _global.dblClick = function (clickSpeed:Number):Boolean  {
			if (!clickSpeed) {
				clickSpeed = 500;
			}
			if (lastclick - (lastclick = getTimer ()) + clickSpeed > 0) {
				return true;
			}
			return false;
		};
	 */
	 
	 private function MiscUtils(){
	 }
}