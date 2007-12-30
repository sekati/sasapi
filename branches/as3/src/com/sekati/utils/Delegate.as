/** * com.sekati.utils.Delegate * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ package com.sekati.utils {	/**	 * @private	 * A delegation proxy (similar to AS2 Delegate) for times when the 	 * built-in method closure doesn't cut it.	 */	public class Delegate {		/**		 * Similar to Delegate		 * @example Usage:		 * private function quack( num:int, s:String ):void {		 * 	trace( "hello" + num + " " + s );		 * }		 * var f:Function = Delegate.create(this, quack, 1, "duck");		 * f( ); // outputs "hello1 duck" 		 */		public static function create(target:Object, fn:Function, ... args):Function {			var proxy:Function = function():void {				fn.apply( target, args );			};			return proxy; 					}	}}