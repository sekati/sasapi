/** * com.sekati.core.Main * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */package com.sekati.core {		import flash.display.MovieClip;	import com.sekati.tests.*;	/**	 * Main	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/	 */	public class Main extends MovieClip {		public function Main() {			trace("woot - movie begins!");			createBox();		}				/**		 * Create a TestBox		 * @return void		 */		private function createBox():void {			//var test:TestBox = stage.addChild(new TestBox());			var test:TestBox = 	new TestBox();			this.addChild(test); // same as stage.addChild(test);			test.alpha = 0;			test.tween({alpha:1, x:700, y:350, time:1, delay:1});				}	}}