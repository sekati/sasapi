/** * com.sekati.tests.SpriteTest * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2008  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ package com.sekati.tests {	import flash.display.Sprite;	import flash.display.Shape;	/**	 * SpriteTest	 */	public class SpriteTest extends Sprite {				protected var _shape0:Shape;		protected var _shape1:Shape;				/**		 * Constructoe		 */		public function SpriteTest() {			_shape0 = new Shape();			_shape1 = new Shape();		}	}}