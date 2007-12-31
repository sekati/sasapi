/** * com.sekati.net.NetBase * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ package com.sekati.net {	import com.sekati.display.Document;	import com.sekati.validate.StringValidation;	import flash.external.ExternalInterface;	import flash.display.LoaderInfo;	/**	 * Static class wrapping various Network utilities.	 */	public class NetBase {		/**		 * return the URL Path swf is running under		 * @return String		 * {@code Usage:		 * 	// run from http://localhost/myProject/site.swf		 * 	trace(NetBase.getPath()); // returns "http://localhost/myProject/"		 * }		 */		public static function getPath():String {			var _url:String = Document.root.loaderInfo.loaderURL;			return( _url.substr( 0, _url.lastIndexOf( '/' ) + 1 ) );		}		/**		 * check if we are online the swf is being executed over http.		 * @return Boolean		 */		public static function isOnline():Boolean {			var _url:String = Document.root.loaderInfo.loaderURL;			return StringValidation.isURL( _url );		}		/**		 * add a cache killing querystring to url		 * @param url (String)		 * @return String		 * {@code Usage:		 * 	var ckUrl = NetBase.noCacheUrl("http://localhost/page.html"); // returns: http://localhost/page.html?030533		 * }		 */		public static function noCacheUrl(url:String):String {			return url + "?" + new Date( ).getTime( );			}		public static function getHtmlUrl():String {			return ExternalInterface.call( 'function(){return location.href}' );			}	}}