/**
 * com.sekati.service.Flink
 * @version 2.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import flash.external.ExternalInterface;
/**
 * Easily add deeplinking into flash sites
 * 
 * {@code Usage:
 * // Add Flink.js to your swf html page:
 * <script language="javascript" src="js/Flink.js"></script>
 *
 * // enable swLiveConnect:
 * fscommand ("swLiveConnect", "true");
 * }
 */
class com.sekati.service.Flink {
	private static var _link:String;
	private static var _isAvailable:Boolean = ExternalInterface.available;
	/**
	 * get deeplink anchor
	 * @return String
	 * {@code Usage:
	 * var currentDeeplink:String = Flink.getLink();
	 * }
	 */
	public static function getLink ():String {
		_link = String (ExternalInterface.call ("getFlink"));
		trace ("*** Flink.getLink = '" + _link + "'");
		return (_link);
	}
	/**
	 * set deeplink anchor and page title
	 * @return String
	 * {@code
	 * Flink.setLink("Section Three","section_three");
	 * }
	 */
	public static function setLink (pgTitle:String, anchor:String):Void {
		ExternalInterface.call ("setFlink", pgTitle, anchor);
		_link = anchor;
		trace ("*** Flink.setLink = '" + _link + "'");
	}
	/**
	 * call a javascript function from actionscript
	 * @return Void
	 * {@code
	 *  Flink.jsCall ("helloWorld", "boy", "jason");
	 * }
	 */
	public static function jsCall () {
		ExternalInterface.call.apply (null, arguments);
	}
	/**
	 * allow javascript access to call an actionscript function
	 * @param fnName (String) as function name as string
	 * @param instance (Object) scope of fnName
	 * @param fn (Function) as function name
	 * @return Void
	 * {@code Usage:
	 * Flink.jsAllow ("helloFlash", this, helloFlash);
	 * }
	 */
	public static function jsAllow (fnName:String, instance:Object, fn:Function):Void {
		trace ("*** Flink.setAvailable: '" + fnName + "'");
		ExternalInterface.addCallback (fnName, instance, fn);
	}
	
	private function Flink(){}
	//
}
// eof