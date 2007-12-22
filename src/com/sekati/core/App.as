 /**
 * com.sekati.core.App
 * @version 5.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.data.XML2Object;
import com.sekati.events.Broadcaster;
import com.sekati.log.Logger;
import com.sekati.net.NetBase;
import com.sekati.services.Urchin;
import com.sekati.ui.ContextualMenu;
import com.sekati.validate.StringValidation;
import TextField.StyleSheet;

/**
 * Static class for centralizing & storing core application instances, listeners,
 * broadcasters, debuggers, objects, vars & constants.
 * {@code Usage:
 *	com.sekati.core.App.init();
 * }
 */
class com.sekati.core.App {

	public static var APP_NAME:String;
	public static var PATH:String = ( NetBase.isOnline( ) ) ? NetBase.getPath( ) : "";
	public static var CONF_URI:String = ( !_root.conf_uri ) ? App.PATH + "xml/config.xml" : _root.conf_uri;
	public static var CROSSDOMAIN_URI:String;
	public static var DATA_URI:String;
	public static var CSS_URI:String;
	public static var DEBUG_ENABLE:Boolean;
	public static var FLINK_ENABLE:Boolean;
	public static var TRACK_ENABLE:Boolean;
	public static var KEY_ENABLE:Boolean;
	private static var BOOTSTRAP_RETRY:Number = 0;
	private static var BOOTSTRAP_RETRY_MAX:Number = 5;	
	public static var DATA_PATH:String;
	public static var BUFFER_TIME:Number;
	public static var log:Logger;
	public static var bc:Object = Broadcaster.getInstance( );
	public static var db:Object = new Object( );
	public static var css:TextField.StyleSheet = new StyleSheet( );
	/**
	 * App bootstrap props
	 * _bootstrapChain (Array) list of methods to run to bootstrap App
	 *  _bootstrapCounter (Number) bootstrap stage counter
	 */
	private static var _bootstrapChain:Array = [ 'loadConfig', 'loadStyle', 'loadData' ];
	private static var _bootstrapCounter:Number = -1;

	/**
	 * init begins the bootstrap process
	 * @return Void
	 */
	public static function init():Void {
		trace( "*** - App Initialized ...\n" );
		Urchin.track( "home" );
		trace( "TEST: " + Flink );
		App.bc.broadcast( "onBootstrap" );
		App.bootstrap( );
	}

	/**
	 *loop through bootstrapChain method array
	 * @return Void
	 */
	private static function bootstrap():Void {
		App._bootstrapCounter++;
		if( _bootstrapCounter < _bootstrapChain.length ) {
			var methodName:String = App._bootstrapChain[ App._bootstrapCounter ];
			App[ methodName ]( );
		} else {
			App.bc.broadcast( "onAppConfigured" );
			App.log.status( "App", "@@@ onAppConfigured EVENT FIRED - Application Full INIT!" );
		}
	}

	/**
	 * a method in the bootstrap chain failed - make retry attempts at each phase.
	 * @return Void
	 */
	private static function bootstrap_retry():Void {
		if( App.BOOTSTRAP_RETRY < App.BOOTSTRAP_RETRY_MAX ) {
			trace( "!!! BOOTSTRAP FAILED ON " + _bootstrapChain[ _bootstrapCounter ] + "() !!! ::: BOOTSTRAP RETRY ATTEMPT: [" + App.BOOTSTRAP_RETRY + "/" + App.BOOTSTRAP_RETRY_MAX + "]" );
			App.BOOTSTRAP_RETRY++;
			App[ _bootstrapChain[ _bootstrapCounter ] ]( );
		} else {
			trace( "!!! BOOTSTRAP FATALLY BOMBED WITH  " + _bootstrapChain + "() !!! ::: BOOTSTRAP RETRY ATTEMPT: [" + App.BOOTSTRAP_RETRY + "/" + App.BOOTSTRAP_RETRY_MAX + "] ::: Sorry, I tried but the application failed to boot." );
		}
	}	

	/**
	 * loads and parses config.xml then broadcasts "onConfig"
	 * @return Void
	 */
	private static function loadConfig():Void {
		var oXML:XML = new XML( );
		var o:Object = new Object( );
		oXML.ignoreWhite = true;
		var xmlLoaded:Function = function( success:Boolean ):Void {
			if ( success ) {
				o = new XML2Object( ).parseXML( oXML );
				// dump object data into static App vars
				App.APP_NAME = o.config.attributes.name + " v" + o.config.attributes.version;
				App.CROSSDOMAIN_URI = ( o.config.crossdomain_uri.data != undefined ) ? o.config.crossdomain_uri.data : "crossdomain.xml";
				App.CROSSDOMAIN_URI = ( StringValidation.isURL( App.CROSSDOMAIN_URI ) ) ? App.CROSSDOMAIN_URI : NetBase.getPath( ) + App.CROSSDOMAIN_URI;
				App.CSS_URI = o.config.css_uri.data;
				App.DEBUG_ENABLE = ( o.config.debug_enable.data == "true" ) ? true : false;
				App.FLINK_ENABLE = ( o.config.flink_enable.data == "true" ) ? true : false;
				App.TRACK_ENABLE = ( o.config.track_enable.data == "true" ) ? true : false;
				App.KEY_ENABLE = ( o.config.key_enable.data == "true" ) ? true : false;
				App.DATA_PATH = ( o.config.data_path.data != undefined ) ? o.config.data_path.data : "";
				App.BUFFER_TIME = Number( o.config.buffer_time.data );
				// custom content
				App.COPY1 = o.config.copy_1.data;
				App.COPY2 = o.config.copy_2.data;
				App.COPY3 = o.config.copy_3.data;
				App.IMG1 = o.config.img_1.data;
				App.IMG2 = o.config.img_2.data;
				App.IMG3 = o.config.img_3.data;
				App.FLV_URI = o.config.flv.data;
				// enact config.xml settings 
				if ( App.DEBUG_ENABLE == true ) {
					App.log = Logger.getInstance( );
					App.log.isIDE = true, 
					App.log.isLC = true, 
					App.log.isSWF = false;					
					App.log.trace( "App", "@@@ Debug enabled ..." );
				}
				// enable context menu                    
				App.log.trace( "@@@ Setting ContextMenu ..." );
				var cm:ContextualMenu = new ContextualMenu( _level0 );
				cm.addItem( App.APP_NAME );
				
				// load crossdomain policy 
				App.log.trace( this, "@@@ loading crossdomain policy: " + App.CROSSDOMAIN_URI );
				System.security.loadPolicyFile( App.CROSSDOMAIN_URI );
				delete oXML;
				delete o;
				App.bc.broadcast( "onConfig" );
				App.bootstrap( );
			} else {
				bootstrap_retry( );	
			}
		};
		oXML.onLoad = xmlLoaded;
		oXML.load( App.CONF_URI );
	}

	/**
	 * load App stylesheet css from {@code CSS_URI} during {@link bootstrap} sequence.
	 * @return Void
	 * {@code Usage:
	 * 	tf.styleSheet = App.css;
	 * 	tf.htmlText = "<span class='righthead_credit'>Hello World</span>";
	 * }
	 */
	private static function loadStyle():Void {
		var _styleSheet:TextField.StyleSheet = new StyleSheet( );
		_styleSheet.onLoad = function( success:Boolean ):Void {
			if( success ) {
				App.css = _styleSheet;
				App.log.info( "App", "$$$ - Styles loaded (App.CSS) ..." );
				App.bootstrap( );
			} else {
				bootstrap_retry( );	
			}
		};
		_styleSheet.load( App.CSS_URI );
	}

	private function App() {
	}
}