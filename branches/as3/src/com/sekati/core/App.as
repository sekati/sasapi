/** * com.sekati.core.App * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */package com.sekati.core {	import flash.text.StyleSheet;		import com.sekati.display.Canvas;	import com.sekati.log.Logger;	import com.sekati.net.NetBase;		/**	 * App is -the- static class for centralizing & storing core application instances, 	 * listeners, broadcasters, debuggers, objects, vars & constants.	 * 	 * PLEASE NOTE: This class no longer requires any initialization:	 * @see com.project.core.Bootstrap	 */	public dynamic class App {		public static const VERSION:String = 'SASAPI v3.0.0 | http://sasapi.googlecode.com | http://sekati.com';		public static const AUTHOR:String = 'Copyright (C) 2007  jason m horwitz, sekati.com, Sekat LLC. All Rights Reserved.';		public static var APP_NAME:String;		public static var PATH:String = NetBase.isOnline( ) ? NetBase.getPath( ) : "";				// http://blogs.adobe.com/pdehaan/2006/07/using_flashvars_with_actionscr.html		//http://www.kirupa.com/forum/showthread.php?p=1952513		//http://www.senocular.com/flash/actionscript.php?file=ActionScript_3.0/com/senocular/events/StageDetection.as				public static var CONF_URI:String = ( !Canvas.flashVars["conf_uri"] ) ? App.PATH + "xml/config.xml" : Canvas.flashVars["conf_uri"];		public static var CROSSDOMAIN_URI:String;		public static var DATA_URI:String;		public static var CSS_URI:String;				public static var DEBUG_ENABLE:Boolean;		public static var FLINK_ENABLE:Boolean;		public static var TRACK_ENABLE:Boolean;		public static var KEY_ENABLE:Boolean;		public static var FLV_BUFFER_TIME:Number;		public static var log:Logger;		public static var db:Object = new Object( );		public static var css:StyleSheet = new StyleSheet( );		//public static var cmenu:ContextualMenu = new ContextualMenu ( _root );		}}