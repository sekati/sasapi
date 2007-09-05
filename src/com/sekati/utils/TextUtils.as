﻿/** * com.sekati.utils.TextUtils * @version 3.0.1 * @author jason m horwitz | sekati.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ import TextField.StyleSheet;/** * Static class wrapping various Text utilities. */class com.sekati.utils.TextUtils {	/**	 * createTextField wrapper	 * @param scope (MovieClip) target movieclip scope	 * @param instanceName (String) created TextField instance name	 * @param x (Number) x pos	 * @param y (Number) y pos	 * @param w (Number) width	 * @param xh(Number) height	 * @param props (Object) object populated with extra props to apply to TextField	 * @param fprops (Object) object populated with TextFormat properties to apply to TextField	 * @param css (String) CSS Stylesheet to apply; may be either inline css or an external stylesheet url	 * @return TextField	 * 	 * {@code Usage:	 * TextUtils.create(_root, "tf", 10, 10, 100, 20, {antiAliasType:"advanced", autoSize:true, embedFonts:false, html:true, htmlText:"hello world", multiline:true, mouseWheelEnabled:true, selectable:false, type:"dynamic", wordWrap:true}, {font:"Verdana",size:9,color:0x000000});	 * }	 */	public static function create (scope:MovieClip, instanceName:String, x:Number, y:Number, w:Number, h:Number, props:Object, fprops:Object, css:String):TextField {		var t:TextField = scope.createTextField (instanceName, scope.getNextHighestDepth (), x, y, w, h);		for (var i in props) {			t[i] = props[i];		}		if (fprops) {			TextUtils.format (t, fprops);		}		if (css) {			TextUtils.style (t, css);		}		if (props.htmlText || props.text) {			t.htmlText = (props.htmlText) ? props.htmlText : props.text;		}		return t;	}	/**	 * TextFormat wrapper	 * @param tf (TextField) target TextField	 * @param props (Object) object populated with TextFormat props to apply to TextField	 * @return Void	 * 	 * {@code Usage:	 * TextUtils.format(tf, {font:"Verdana",size:9,color:0x000000});	 * }	 */	public static function format (tf:TextField, props:Object, css:String):Void {		var str:String = (tf.html) ? tf.htmlText : tf.text;		var f:TextFormat = new TextFormat ();		for (var i in props) {			f[i] = props[i];		}		tf.setNewTextFormat (f);		if(tf.html) {			tf.htmlText = str;		} else {			tf.text = str;		}	}	/**	 * TextField.StyleSheet wrapper	 * @param tf (TextField) target TextField	 * @param css (String) CSS Stylesheet to apply; may be either inline css or an external stylesheet url	 * @return Void	 * 	 * {@code Usage:	 * TextUtils.style(tf, "css/styles.css");	 * TextUtils.style(tf, "a:link{color:#c20b10; text-decoration:none; font-style:italic;} a:hover{color:#363636; text-decoration:underline; font-style:italic;}");	 * }	 */	public static function style (tf:TextField, css:String):Void {		var str:String = tf.htmlText;		if (css.substr (css.length - 4, 4).toLowerCase () != ".css") {			var _styles:TextField.StyleSheet = new StyleSheet ();			if (_styles.parseCSS (css)) {				tf.styleSheet = _styles;				tf.htmlText = str;			}		} else {			var _styleSheet:TextField.StyleSheet = new StyleSheet ();			_styleSheet.onLoad = function (success:Boolean) {				if (success) {					tf.styleSheet = _styleSheet;					tf.htmlText = str;				}			};			_styleSheet.load (css);		}	}	/**	 * empty a TextField.onSetFocus, restore to default if blank onKillFocus on input textfield	 * @param tf (TextField) target TextField	 * @return Void	 * 	 * {@code Usage:	 * tf.onSetFocus = tf.onKillFocus = function ():Void { TextUtils.focusToggle (tf); };	 * }	 */	public static function focusToggle (tf:TextField):Void {		trace ("focus toggle called");		if (tf.defval.length) {			if (tf.text == tf.defval) {				tf.text = "";			} else if (tf.text == "") {				tf.text = tf.defval;			}		} else if (tf.text.length) {			tf.defval = tf.text;			tf.text = "";		}	}	/**	 * place cursor caret at index of text in textfield	 * @param tf (TextField) target TextField	 * @param index (Number) character number to place caret	 * @return Void	 * 	 * {@code Usage:	 * TextUtils.caret (tf, 5);	 * }	 */	public static function caret (tf:TextField, index:Number):Void {		Selection.setFocus (tf);		Selection.setSelection (index, index);	}	/**	 * select an area of text with cursor within text	 * @param tf (TextField) target TextField	 * @param sIndex (Number) start character index of selection	 * @param eIndex (Number) end character index of selection	 * @return Void	 * {@code Usage:	 * TextUtils.select (tf, 5, 10);	 * }	 */	public static function select (tf:TextField, sIndex:Number, eIndex:Number):Void {		Selection.setFocus (tf);		Selection.setSelection (sIndex, eIndex);	}		/**	 * antiAlias settings for textfield	 * @param tf (TextField) target TextField	 * @param thick (Number) set thickness of antialias [-200 to 200, default:0]	 * @param sharp (Number) set sharpness of antialias [-400 to 400, default:0]	 * @param gridFitType (Number) 0:["none"-for large fonts & anim] 1:["pixel"-for legibility of left-aligned text] 2:["subpixel"-for right-aligned or centered text] [default: 1]	 * @param isAdvanced (Boolean) type of antialias: should be true for anything <48pts [default: true]	 * @return Void	 * {@code Usage:	 * TextUtils.antiAlias (tf, 200, -200, 1, true);	 * }	 */	public static function antiAlias (tf:TextField, thick:Number, sharp:Number, gridFitType:Number, isAdvanced:Boolean):Void {		var fits:Array = ["none", "pixel", "subpixel"];		tf.antiAliasType = (!isAdvanced) ? "normal" : "advanced";		tf.thickness = (thick) ? thick : 0;		tf.sharpness = (sharp) ? sharp : 0;		tf.gridFitType = (gridFitType && gridFitType <= 2) ? fits[gridFitType] : fits[1];	}		/**	 * ellipse text after the defined number of lines	 * @param tf (TextField) target TextField	 * @param n (Number) number of lines of text desired	 * @param ellipseLine (Boolean) ellipse at exact end of line [true] or after the last full word [false]	 * @return Void	 */	public static function excerpt (tf:TextField, n:Number, ellipseLine:Boolean):Void {		if (tf.bottomScroll > n) {			var len:Number = tf.text.length;			for (var i:Number = 0; i < len; i++) {				tf.scroll = tf.maxscroll;				if (tf.bottomScroll > n) {					tf.text = tf.text.slice (0, -1);				} else {					var e:Number = (ellipseLine) ? -3 : tf.text.lastIndexOf (" ");					tf.text = tf.text.slice (0, e);					tf.text += "...";					break;				}			}		}	}		/**	 * chop single-line text to width, use optional ellipse	 * @param tf (TextField) target text	 * @param cutW (Number) desired text width	 * @param ellipse (Boolean) add ...	 * @param longEllipse (Boolean) add ... to end of textField (currently not working)	 * @return Void	 */	public static function chop (tf:TextField, cutW:Number, ellipse:Boolean, longEllipse:Boolean):Void {		cutW = (!longEllipse) ? cutW - 3 : cutW -= 10;		if (tf.textWidth <= cutW && !longEllipse) {			return;		}		tf._visible = false;		var str:String = tf.text;		//tf.autoSize = true;		tf.text = "W";		var ww:Number = tf.textWidth;		tf.text = "A";		var aw:Number = tf.textWidth;		var ptr:Number = Math.floor (cutW / ww);		var origLen:Number = str.length;		var checkS:String = str.substr (0, ptr);		tf.text = checkS;		var cnt:Number;		while (tf.textWidth < cutW) {			cnt = Math.floor ((cutW - tf.textWidth) / aw);			if (cnt == 0) {				break;			}			ptr += cnt;			ptr = (ptr > origLen) ? origLen : ptr;			checkS = str.substr (0, ptr);			tf.text = checkS;			if (origLen == ptr) {				break;			}		}		tf.text = (ellipse) ? tf.text + "..." : tf.text;		if (tf.textWidth > cutW) {			while (tf.textWidth > cutW) {				checkS = checkS.substr (0, -1);				tf.text = ellipse ? checkS + "..." : checkS;			}		}		if (longEllipse) {			tf._parent.tf2.text = ".";			var periodW:Number = tf._parent.tf2.textWidth;			tf._parent.tf2.text = "";			var whiteSp:Number = cutW - tf.textWidth + 8;			var i:Number = Math.floor (whiteSp / periodW);			while (i-- > 0) {				tf._parent.tf2.text += ".";			}			if (whiteSp < tf._parent.tf2.textWidth) {				while (whiteSp < tf._parent.tf2.textWidth) {					tf._parent.tf2.text = tf._parent.tf2.text.substr (0, -1);				}			} else if (whiteSp > tf._parent.tf2.textWidth) {				while (tf._parent.tf2.textWidth < whiteSp) {					tf._parent.tf2.text += ".";				}				tf._parent.tf2.text = tf._parent.tf2.text.substr (0, -1);			}		}		tf._visible = true;	}		/**	 * simple chop single-line text to width, use optional ellipse (unoptimized version of above)	 * @param tf (TextField) target text	 * @param maxW (Number) desired text width	 * @param ellipse (Boolean) add ...	 * @return Void	 */	public static function simpleChop (tf:TextField, maxW:Number, ellipse:Boolean):Void {		var dots:String = "", oht:Boolean = tf.html, cn:String = "$__chop__" + tf._name;		if (!maxW) {			maxW = tf._width;		}		if (ellipse) {			dots = "...";		}		if (tf._parent[cn]) {			tf._parent[cn].removeTextField ();		}		var chopField = tf._parent.createTextField (cn, tf._parent.getNextHighestDepth (), -1000, -1000, 1000, 1000);		tf.html = true, chopField.html = true, chopField.type = tf.type, chopField._visible = 0;		chopField.setTextFormat (tf.getTextFormat ());		chopField.htmlText = "W";		// test character width		maxW -= chopField.textWidth;		// padding (note: the longer the string, the more padding is required)		chopField.htmlText = tf.htmlText;		var tw = chopField.textWidth;		if (tw > maxW) {			var t = tf.htmlText;			while (tw > maxW) {				t = t.substr (0, t.length - 1);				chopField.htmlText = t + dots;				tw = chopField.textWidth;			}			tf.htmlText = t + dots;		}		tf.html = oht;		chopField.removeTextField ();	}		private function TextUtils(){	}}