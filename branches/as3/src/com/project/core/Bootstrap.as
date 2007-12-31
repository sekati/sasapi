/** * com.project.core.Bootstrap * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ package com.project.core {	import com.sekati.core.App;	import com.sekati.convert.BoolConversion;	import com.sekati.events.AppEvent;	import com.sekati.log.Logger;	import com.sekati.net.NetBase;	import com.sekati.validate.StringValidation;	import flash.net.URLLoader; 	import flash.net.URLRequest;		import flash.events.*;	//import flash.errors.*;	import flash.text.StyleSheet;	/**	 * Bootstrap runs thru the _sequenceChain of methods to prepare	 * {@link com.sekati.core.App} by loading config, data, stylesheet, as	 * well as any other custom methods needed to bootstrap the application	 * and firing the {@code onAppConfigured } event.	 * 	 * @see http://en.wikipedia.org/wiki/Bootstrapping_%28computing%29	 * @see http://www.partlyhuman.com/blog/roger/as3-e4x-rundown	 * @see http://www.flash-db.com/Tutorials/loadingAS3/loadingData.php?page=3	 * @see http://www.betriebsraum.de/blog/2007/06/22/runtime-font-loading-with-as3-flash-cs3-not-flex/	 */	public class Bootstrap extends EventDispatcher {		/**		 * Bootstrap properties:		 * _sequenceChain (Array) list of methods to run during bootstrap		 * _sequenceCount (Number) bootstrap stage counter		 * RETRY_ATTEMPT (Number) bootstrap retry counter		 * RETRY_MAX (Number) maximum retries before Bootstrap errors out.		 */		private var _this:Bootstrap;		private static var _sequenceChain:Array = [ 'loadConfig', 'loadData', 'loadStyle' ];		private static var _sequenceCount:Number = 0;		private static var RETRY_ATTEMPT:Number = 0;		private static var RETRY_MAX:Number;			/**		 * Constructor		 * @param maxRetryAttempts (Number) times to retry each method in bootstrap before fatal error.		 */		public function Bootstrap(maxRetryAttempts:Number = 5) {			super( );			RETRY_MAX = maxRetryAttempts;			_this = this;			trace( "*** - Bootstrap Initialized ...\n" );			//Urchin.track( "home" );			run( );		}		/**		 * Iterate through _sequenceChain method array then fire the "onAppConfigured" events		 * @return void		 * @see com.sekati.events.AppEvent		 */		private function run():void {			if (_sequenceCount < _sequenceChain.length) {				var methodName:String = _sequenceChain[_sequenceCount];				trace( _sequenceCount + " of " + _sequenceChain.length );				trace( "running method [" + _sequenceCount + "]" + methodName );				//Logger.$.trace( _this, "running method [" + _sequenceCount + "]" + methodName );				_sequenceCount++;				_this[methodName]( );			} else {				dispatchEvent( new AppEvent( AppEvent.APP_INIT ) );				//Logger.$.status( _this, "@@@ Application Configured: auto-initialization via broadcast event ..." );				trace( "@@@ Application Configured: auto-initialization via dispatched event ... " + AppEvent.APP_INIT );			}		}		/**		 * A method in the sequence chain failed - make retry attempts 		 * at each phase or die with fatal exception.		 * @return Void		 * @throws FatalOperationException		 */		private function retry():void {			if (RETRY_ATTEMPT < RETRY_MAX) {				trace( "Bootstrap attempt failed in sequence chain " + _sequenceCount + ": " + _sequenceChain[_sequenceCount] + "()\n Retry Attempt: [" + RETRY_ATTEMPT + " of " + RETRY_MAX + "]" );				//Logger.$.warn( _this, "Bootstrap attempt failed in sequence chain " + _sequenceCount + ": " + _sequenceChain[_sequenceCount] + "()\n Retry Attempt: [" + RETRY_ATTEMPT + " of " + RETRY_MAX + "]" );				RETRY_ATTEMPT++;				_this[_sequenceChain[_sequenceCount]]( );			} else {				var msg:String = "Bootstrap died in sequence chain " + _sequenceCount + ": " + _sequenceChain[_sequenceCount] + "()\nRetry Attempt: [" + RETRY_ATTEMPT + " of " + RETRY_MAX + "]\n Sorry, I tried but the application failed to boot.";				trace( msg );				//Logger.$.fatal( _this, msg );				//throw new FatalOperationException( _this, msg, arguments );			}		}			// SEQUENCED BOOTSTRAP METHODS		/**		 * loads and parses config.xml then broadcasts "onConfig"		 * @return Void		 */		private function loadConfig():void {			var request:URLRequest = new URLRequest( "xml/config.xml" );			var loader:URLLoader = new URLLoader( );			var onLoadXML:Function = function(e:Event):void {				try {					var cXML:XML = new XML( e.target.data );					App.db.config = cXML;					dispatchEvent( new AppEvent( AppEvent.APP_CONFIG ) );					//trace( App.db.config );					//Logger.$.status( _this, "$$$ - Data loaded (App.db) ..." );					run( );									} catch (te:TypeError) {					// Could not convert the data, probably because is not formatted properly					trace( "Could not parse the XML" );					trace( te.message );				}							};			var onErrorXML:Function = function(e:Event):void {				retry( );			};			loader.addEventListener( Event.COMPLETE, onLoadXML );			loader.addEventListener( IOErrorEvent.IO_ERROR, onErrorXML );			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorXML );			loader.load( request );						/*			var oXML:XML = new XML( );			var o:Object = new Object( );			oXML.ignoreWhite = true;							var parseConfiguration:Function = function (success:Boolean):void {			if (!success) {			retry( );			return;				}			o = new XML2Object( ).parseXML( oXML );			App.db.config = o.config;			// dump core config values into static App constants			App.APP_NAME = o.config.attributes.name + " v" + o.config.attributes.version;							App.CROSSDOMAIN_URI = (o.config.crossdomain_uri.data != undefined) ? o.config.crossdomain_uri.data : "crossdomain.xml";			App.CROSSDOMAIN_URI = (StringValidation.isURL( App.CROSSDOMAIN_URI )) ? App.CROSSDOMAIN_URI : NetBase.getPath( ) + App.CROSSDOMAIN_URI;			App.DATA_URI = o.config.data_uri.data;			App.CSS_URI = o.config.css_uri.data;							App.DEBUG_ENABLE = BoolConversion.toBoolean( o.config.debug_enable.data );			App.FLINK_ENABLE = BoolConversion.toBoolean( o.config.flink_enable.data );			App.TRACK_ENABLE = BoolConversion.toBoolean( o.config.track_enable.data );			App.KEY_ENABLE = BoolConversion.toBoolean( o.config.key_enable.data );			App.FLV_BUFFER_TIME = Number( o.config.flv_buffer_time.data );			if (App.DEBUG_ENABLE == true) {			App.log = Logger.getInstance( );			Logger.$.isIDE = true, 			Logger.$.isLC = true, 			Logger.$.isSWF = false;								Logger.$.info( _this, "@@@ Debug enabled ..." );			}							// enable context menu 			Logger.$.info( _this, "@@@ Setting ContextMenu ..." );			//App.cmenu.addItem( App.APP_NAME );						// load crossdomain policy 			Logger.$.info( _this, "@@@ loading crossdomain policy: " + App.CROSSDOMAIN_URI );			//System.security.loadPolicyFile( App.CROSSDOMAIN_URI );			delete oXML;			delete o;			Logger.$.status( _this, "$$$ - Config loaded ..." );			//Broadcaster.$.broadcast( "onLoadAppConfig" );			run( );			};			oXML.onLoad = parseConfiguration;			oXML.load( App.CONF_URI );			 */		}		/**		 * load App data from {@code DATA_URI} during {@link bootstrap} sequence.		 * @return Void		 */		private function loadData():void {			var request:URLRequest = new URLRequest( App.db.config.data_uri );			var loader:URLLoader = new URLLoader( );			var onLoadXML:Function = function(e:Event):void {				try {					var dXML:XML = new XML( e.target.data );					App.db.data = dXML;					dispatchEvent( new AppEvent( AppEvent.APP_DATA ) );					//trace( App.db.data );					//trace(App.db.data.person.(@name == "Jason M Horwitz").age);					//Logger.$.status( _this, "$$$ - Data loaded (App.db) ..." );					run( );									} catch (te:TypeError) {					// Could not convert the data, probably because is not formatted properly					trace( "Could not parse the XML" );					trace( te.message );				}							};			var onErrorXML:Function = function(e:Event):void {				retry( );			};			loader.addEventListener( Event.COMPLETE, onLoadXML );			loader.addEventListener( IOErrorEvent.IO_ERROR, onErrorXML );			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorXML );			loader.load( request );		}			/**		 * load App stylesheet css from {@code CSS_URI} during {@link bootstrap} sequence.		 * @return Void		 * {@code Usage:		 * 	tf.styleSheet = App.css;		 * 	tf.htmlText = "<span class='righthead_credit'>Hello World</span>";		 * }		 */		private function loadStyle():void {			var request:URLRequest = new URLRequest( App.db.config.css_uri );			var loader:URLLoader = new URLLoader( );			var onLoadCSS:Function = function(e:Event):void {				var sheet:StyleSheet = new StyleSheet( );  				sheet.parseCSS( loader.data );				App.css = sheet;				dispatchEvent( new AppEvent( AppEvent.APP_STYLE ) );				//Logger.$.status( _this, "$$$ - Styles loaded (App.CSS) ..." );				run( );			};			var onErrorCSS:Function = function (e:Event):void {				retry( );			};			loader.addEventListener( Event.COMPLETE, onLoadCSS );			loader.addEventListener( IOErrorEvent.IO_ERROR, onErrorCSS );			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorCSS );			loader.load( request );							}	}}