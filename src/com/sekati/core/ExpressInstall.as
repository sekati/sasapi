﻿/** * com.sekati.core.ExpressInstall * @version 1.0.3 * @author jason m horwitz | sekati.com * Copyright (c) 2007  jason m horwitz | Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ /** * This class invokes the Adobe  Flash Player Express Install functionality if an update is required. * {@code Flash Usage: * // first line of code in your fla (before preloader)  * var expressInstall:ExpressInstall = new ExpressInstall(); * } * {@code swfIN Usage: * <script type="text/javascript">  * 	var f = new swfIN("foo.swf", "foo", "640", "480");  * 	f.useExpressInstall(); * 	f.detect(9, "d", "no_flash"); * 	f.write(); * </script> * } * Note: Your Flash movie must be at least 214px by 137px in order to use ExpressInstall. */class com.sekati.core.ExpressInstall {	private var _this:ExpressInstall;	private var _updater:MovieClip;	private var _holder:MovieClip;/** * Constructor checks flash player version and stops movie to * invokes Express Install if update is required. */	public function ExpressInstall () {		_this = this;		if (_root.MMplayerType != undefined)  loadUpdater ();	}	private function loadUpdater ():Void {		_root.stop ();		System.security.allowDomain ("fpdownload.macromedia.com");		_updater = _root.createEmptyMovieClip ("expressInstallHolder", 10000000);		// register the callback so we know if they cancel or there is an error		_updater.installStatus = onInstallStatus;		_holder = _updater.createEmptyMovieClip ("_holder", 1);		// can't use movieClipLoader because it has to work in 6.0.65		_updater.onEnterFrame = function ():Void  {			if (typeof _holder.startUpdate == 'function') {				_this.initUpdater ();				_updater.onEnterFrame = null;			}		};		_holder.loadMovie ("http://fpdownload.macromedia.com/pub/flashplayer/" + "update/current/swf/autoUpdater.swf?" + Math.random ());	}	private function initUpdater ():Void {		_holder.redirectURL = _root.MMredirectURL;		_holder.MMplayerType = _root.MMplayerType;		_holder.MMdoctitle = _root.MMdoctitle;		_holder.startUpdate ();	}	/**	 * onInstallStatus event handler method; currently unimplemented but can be customized to your needs	 * @param msg (String) status message	 * @return Void	 */	public function onInstallStatus (msg:String):Void {		//getURL ("javascript:alert('update required');", "_self");	}}// eof