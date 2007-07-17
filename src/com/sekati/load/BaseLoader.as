/**
 * com.sekati.load.BaseLoader
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.core.FWDepth;
import com.sekati.utils.Delegate;
/**
 * generic root preloader - stops movie, preloads, then advances to defined frame label.
 * {@code Usage: 
 * var preload:BaseLoader = new BaseLoader("finalFrameLabel");
 * }
 */
class com.sekati.load.BaseLoader {
	private var _nextFrameLabel:String;
	private var _loader:MovieClip;
	private var _isLoaded:Boolean;
	private var _l:Number;
	private var _t:Number;
	private var _p:Number;
	/**
	 * constructor
	 * @param frameLabel (String) the root framelabel to advance to when preload is complete [default: "bootstrap"]
	 */
	public function BaseLoader(frameLabel:String) {
		_nextFrameLabel = (!frameLabel) ? "bootstrap" : frameLabel;
		_isLoaded = false;
		_root.stop();
		_loader = _root.createEmptyMovieClip ("loader", FWDepth.BaseLoader);
		_loader.onEnterFrame = Delegate.create(this, preload);
	}
	private function preload():Void {
		_l = _root.getBytesLoaded ();
		_t = _root.getBytesTotal ();
		_p = Math.floor(_l/_t*100);
		if (_t > 5 && _l >= _t && Stage.width > 5 && Stage.height > 5) {
			_loader.onEnterFrame = null;
			_loader.removeMovieClip();
			_isLoaded = true;
			_root.gotoAndStop(_nextFrameLabel);	
		}
	}
	public function get percent():Number {
		return _p;	
	}
	public function get bytesLoaded():Number {
		return _l;	
	}
	public function get bytesTotal():Number {
		return _t;	
	}
	public function get isLoaded():Boolean {
		return _isLoaded;	
	}
}