/**
 * com.sekati.geom.IPoint
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Interface describing {@link com.sekati.geom.Point}
 */
interface com.sekati.geom.IPoint {

	function isEqual():Boolean;
	
	function getDistance():Number;
	
	function displace():Point;
	
	function offset():Void;
	
	function clone():Point;
	
	function destroy():Void;
	
	function toString():String;
	
}