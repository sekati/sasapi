
/**
 * com.sekati.transitions.Mot
 * @version 1.0.2
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Mot - Motion Styling template support for {@link caurina.transitions.Tweener}
 * {@code Usage:
 * 	Tweener.addTween(myMc, { _x:500, _y:30, base:Mot.base0 } );
 * 	Tweener.addTween(myMc, { base:Mot.fadeOut } );
 * 	Tweener.addTween(myMc, { base:Mot.fadeTo(50), onComplete:myCallBackFn} );
 * }
 */
class com.sekati.transitions.Mot {
	
	// easing shortcuts
	public static var i:Object = { quint:"easeInQuint", quad:"easeInQuad", quart:"easeInQuart", expo:"easeInExpo" };
	public static var o:Object = { quint:"easeOutQuint", quad:"easeOutQuad", quart:"easeOutQuart", expo:"easeOutExpo" };
	public static var io:Object ={ quint:"easeInOutQuint", quad:"easeInOutQuad", quart:"easeInOutQuart", expo:"easeInOutExpo" };
	
	// timing shortcuts
	public static var t:Object = {s:0.3, s2:0.5, s3:0.7, d:0.3, d2:0.5, d3:1};

	// deprecated "App.mot" mc_tween2 object - kept for backwards compatability
	public static var m:Object = {e:"easeInOutQuint", e2:"easeOutQuint", e3:"easeInOutQuad", e4:"easeOutQuad", e5:"easeInOutQuart", e6:"easeOutQuart", e7:"easeInOutExpo", e8:"easeOutExpo", s:0.3, s2:0.5, d:0.5};
	
	// color shortcuts
	public static var col:Object = {b:0x000000, w:0xFFFFFF, r:0xFF0000, g:0x00FF00, b:0x0000FF, y:0xFFFF00, c:0x00FFFF, m:0xFF00FF};
	
	// preset templates
	public static function get base0():Object { 
		return { time:t.s, transition:io.quint };
	}
	
	public static function get base1():Object {
		return { time:t.s, transition:io.quad };
	}
	public static function get base2():Object {
		return { time:t.s, transition:io.expo };
	}
	
	public static function get fadeIn():Object {
		return Mot.fadeTo(100);	
	}

	public static function get fadeOut():Object {
		return Mot.fadeTo(0);	
	}
	
	/**
	 * Return a base tween object alpha transition
	 * @param a (Number)
	 * @return Object
	 */
	public static function fadeTo(a:Number):Object {
		return { _alpha:a, time:t.s, transition:io.expo };	
	}
	
	/**
	 * Return a base tween object color transition
	 * @param c (Number)
	 * @return Object
	 */
	public static function colorTo(c:Number):Object {
		return { _color:c, time:t.s2, transition:io.quint };	
	}	
	
	/**
	 * Mot Private Constructor
	 */
	private function Mot() {
	}
}