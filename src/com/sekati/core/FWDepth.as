/**
 * com.sekati.core.FWDepth
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * FrameWork Depth Manager to avoid collisions, uses negative depths for safety where appropriate
 */
class com.sekati.core.FWDepth {
	
	public static var ExpressInstall:Number = 10000000;
	public static var BaseLoader:Number = 15999;
	public static var Pulse:Number = -666;
	public static var FLVAudioContainer:Number = -667;
	public static var SoundCenter:Number = -668;
	public static var ScreenProtector = 9996;
		
	private function FWDepth(){
	}
}