 /**
  * com.sekati.core.App
  * @version 3.0.0
  * @author jason m horwitz | sekati.com
  * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
  * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
  */
import com.sekati.data.XML2Object;
import com.sekati.events.Broadcaster;
import com.sekati.log.OutPanel;
import com.sekati.managers.ContextMenuManager;
import com.sekati.managers.StageManager;

import flash.external.ExternalInterface;
 /**
  * static class for centralizing & storing core application instances,  listeners,
  * broadcasters, debuggers, objects, vars & constants.
  *
  * {@code Usage:
  *	com.sekati.core.App.init();
  * 
  * // Core Path Constants for framework init:
  *	PATH (String) swf absolute url
  *	CONF_URI (String) path to configuration xml file [customize via FlashVar conf_uri] 
  * 
  * // config.xml Properties:
  *	APP_NAME (String) application name
  *	CROSSDOMAIN_URI (String) location of crossdomain.xml policy file to load
  *	DEBUG_ENABLE (Boolean) enable DebugPanel
  *	FLINK_ENABLE (Boolean) enable flink deeplinking
  *	TRACK_ENABLE (Boolean) enable google tracking
  *	KEY_ENABLE (Boolean) enable key listeners
  *	DATA_PATH (String) path to data feeds
  *	BUFFER_TIME (Number) flv buffer time
  *	COPY (String) misc copy
  *	IMG (String) misc images 
  *  
  * // Core Objects for framework setup:
  *	debug (Object) DebugPanel
  *	bc (Broadcaster) broadcaster
  *	sl (Object) stage listener
  *	db (Object) storage object  to load external data in to
  *	mot (Object) mc_tween2 preset references
  *	col (Object) color preset references
  * }
  */
class com.sekati.core.App {
	public static var PATH:String = (_root._url.substring (0, 7) == "http://") ? _root._url.substr (0, _root._url.lastIndexOf ('/') + 1) : "";
	public static var CONF_URI:String = (!_root.conf_uri) ? App.PATH + "config.xml" : _root.conf_uri;
	public static var APP_NAME:String;
	public static var CROSSDOMAIN_URI:String;
	public static var DEBUG_ENABLE:Boolean;
	public static var FLINK_ENABLE:Boolean;
	public static var TRACK_ENABLE:Boolean;
	public static var KEY_ENABLE:Boolean;
	public static var DATA_PATH:String;
	public static var BUFFER_TIME:Number;
	public static var COPY1:String;
	public static var COPY2:String;
	public static var COPY3:String;
	public static var IMG1:String;
	public static var IMG2:String;
	public static var IMG3:String;
	public static var FLV_URI:String;
	public static var debug:Object;
	public static var bc:Object = Broadcaster.getInstance();
	public static var sl:Object = StageManager.getInstance ();
	public static var db:Object = new Object ();
	public static var mot:Object = {e:"easeInOutQuint", e2:"easeOutQuint", e3:"easeInOutQuad", e4:"easeOutQuad", s:0.6, d:0.4};
	public static var col:Object = {b:0x000000, w:0xFFFFFF, r:0xFF0000, g:0x00FF00, b:0x0000FF, y:0xFFFF00, c:0x00FFFF, m:0xFF00FF};
	/**
	 * App bootstrap props
	 * _bootstrapChain (Array) list of methods to run to bootstrap App
	 *  _bootstrapCounter (Number) bootstrap stage counter
	 */
	private static var _bootstrapChain:Array = ['loadConfig'];
	private static var _bootstrapCounter:Number = -1;
	/**
	 * init begins the bootstrap process
	 * @return Void
	 */
	public static function init ():Void {
		trace ("App init ...");
		App.bc.broadcast ("onBootstrap");
		App.bootstrap ();
	}
	/**
	 *loop through bootstrapChain method array
	 * @return Void
	 */
	private static function bootstrap ():Void {
		App._bootstrapCounter++;
		if (_bootstrapCounter < _bootstrapChain.length) {
			var methodName:String = App._bootstrapChain[App._bootstrapCounter];
			App[methodName] ();
		} else {
			App.bc.broadcast ("onAppConfigured");
		}
	}
	/**
	 * loads and parses config.xml then broadcasts "onConfig"
	 * @return Void
	 */
	private static function loadConfig ():Void {
		var oXML:XML = new XML ();
		var o:Object = new Object ();
		oXML.ignoreWhite = true;
		var xmlLoaded = function (success:Boolean):Void {
			if (success) {
				o = new XML2Object ().parseXML (oXML);
				// dump object data into static App vars
				App.APP_NAME = o.config.attributes.name + " v" + o.config.attributes.version;
				App.CROSSDOMAIN_URI = (o.config.crossdomain_uri.data != undefined) ? o.config.crossdomain_uri.data : "crossdomain.xml";
				App.DEBUG_ENABLE = (o.config.debug_enable.data == "true") ? true : false;
				App.FLINK_ENABLE = (o.config.flink_enable.data == "true") ? true : false;
				App.TRACK_ENABLE = (o.config.track_enable.data == "true") ? true : false;
				App.KEY_ENABLE = (o.config.key_enable.data == "true") ? true : false;
				App.DATA_PATH = (o.config.data_path.data != undefined) ? o.config.data_path.data : "";
				App.BUFFER_TIME = Number (o.config.buffer_time.data);
				// custom content
				App.COPY1 = o.config.copy_1.data;
				App.COPY2 = o.config.copy_2.data;
				App.COPY3 = o.config.copy_3.data;
				App.IMG1 = o.config.img_1.data;
				App.IMG2 = o.config.img_2.data;
				App.IMG3 = o.config.img_3.data;
				App.FLV_URI = o.config.flv.data;
				// enact config.xml settings 
				if (App.DEBUG_ENABLE == true) {
					App.debug = OutPanel.getInstance();
					App.debug.trace ("@@@ Debug enabled ...");
				}
				// enable context menu                    
				App.debug.trace ("@@@ Setting ContextMenu ...");
				var cm = new ContextMenuManager ();
				// load crossdomain policy
				App.debug.trace ("@@@ loading crossdomain policy: " + App.CROSSDOMAIN_URI);
				System.security.loadPolicyFile (App.CROSSDOMAIN_URI);
				delete oXML;
				delete o;
				App.bc.broadcast ("onConfig");
				App.bootstrap ();
			}
		};
		oXML.onLoad = xmlLoaded;
		oXML.load (App.CONF_URI);
	}
	/**
	* wrappers to JavaScript tracking & flink deeplinking methods
	* @param page (String) page to be tracked 
	* @return Void
	*/
	public static function track (page:String):Void {
		if (!App.TRACK_ENABLE) {
			return;
		}
		App.debug.trace ("* App.track: " + "(" + page + ")");
		ExternalInterface.call ("urchinTracker", page);
	}
	/**
	 * wrapper to getFlink JavaScript lib - returns object from deeplink anchor
	 * @return Object
	 */
	public static function getFlink ():Object {
		var j = ExternalInterface.call ("getFlink");
		var a:Array = j.split ("/");
		var p:String = (!a[1]) ? "" : a[1];
		App.debug.trace ("* App.getFlink (" + p + ")");
		var flink:Object = {page:p};
		return flink;
	}
	/**
	 * wrapper to setFlink JavaScript lib - sets the current deeplink anchor
	 * @param page (String)
	 * @return Void
	 */
	public static function setFlink (page:String):Void {
		if (!App.FLINK_ENABLE) {
			return;
		}
		App.debug.trace ("* App.setFlink (" + page + ")");
		ExternalInterface.call ("setFlink", null, page);
	}
	/**
	 * wrapper to Flink JavaScript lib - returns the entire current url
	 * @return String
	 */
	public static function getRef ():String {
		var r = ExternalInterface.call ("getRef");
		return r;
	}
	//
}
// eof
