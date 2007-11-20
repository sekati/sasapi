/** * com.sekati.display.BaseClip * @version 1.0.3 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */package com.sekati.display {		import flash.display.MovieClip;	//import com.sekati.core.KeyFactory;	import com.sekati.transitions.Tweener;	/**	 * BaseClip	 * @see http://www.actionscript.com/Article/tabid/54/ArticleID/ActionScript-3-0-Display-Lists-and-Display-Object/Default.aspx	 */	public class BaseClip extends MovieClip {			protected var _this:MovieClip;		public function BaseClip() {			_this = this;			//KeyFactory.inject(_this);		}				/**		 * A very basic wrapper to apply a tween to the instance via com.sekati.transitions.Tweener		 * @param tweenerObj		 * @return Boolean		 * @see http://hosted.zeh.com.br/tweener/docs/en-us/		 * @example _this.tween({_x:50, _alpha:100, time:1, delay:1, transition:"linear", onStart:show, onUpdate:redraw, onComplete:hide});		 */		public function tween(tweenerObj:Object):Boolean {			return Tweener.addTween(_this, tweenerObj);		}				public override function toString():String {			return(this.name);		}			}}