/**
 * com.sekati.ui.ScreenProtector
 * @version 0.9.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.FWDepth;
 import com.sekati.display.BaseClip;
 import com.sekati.draw.Rectangle;
 import com.sekati.reflect.Stringifier;
 import com.sekati.utils.ClassUtils;
 
/**
 * Lock Screen UI
 * TODO - finish class
 */
class com.sekati.ui.ScreenProtector {
	
	public static var DEFAULT_ID : String = "ScreenProtector";
	public static var DEFAULT_DEPTH : Number = FWDepth.ScreenProtector;
	
	public function ScreenProtector (){
	}
	
	/**
	 * Override with reflective output.
	 * @return String
	 */
	public function toString():String {
		return Stringifier.stringify(this);	
	}	
	
}