﻿/**
 * com.sekati.ui.FLVPlayer
 * @version 1.1.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.App;
import com.sekati.core.FWDepth;
import com.sekati.data.FLV;
import com.sekati.utils.Delegate;
import com.sekati.display.CoreClip;

/**
 * FLVPlayer controller to be used with {@link com.sekati.data.FLV}
 */
class com.sekati.ui.FLVPlayer extends CoreClip {

	private var _video:Object;
	private var _playBtn:MovieClip;
	private var _progBar:MovieClip;
	private var _buffBar:MovieClip;
	private var _guttBar:MovieClip;
	private var _volBtn:MovieClip;
	private var _audioContainer:MovieClip;
	private var _movie:Object;
	private var _isDrag:Boolean;
	private var _isSeeking:Boolean;
	private var _wasPlaying:Boolean;
	private var _keyListener:Object;
	private var _isKeyEnabled:Boolean;

	// constructor
	private function FLVPlayer () {
	}

	/**
	 * init called via CoreClip onLoad event
	 * @return Void
	 */
	public function configUI ():Void {
		_video = _this.video;
		_playBtn = _this.playBtn;
		_progBar = _this.progBar;
		_buffBar = _this.buffBar;
		_guttBar = _this.guttBar;
		_volBtn = _this.volBtn;
		_audioContainer = _this.createEmptyMovieClip("audioContainer", FWDepth.FLVAudioContainer);
		// general ui setup
		App.bc.subscribe (_this);
		_progBar._xscale = 0;
		_buffBar._xscale = 0;
		_isDrag = false;
		_isSeeking = false;
		_wasPlaying = false;
		_isKeyEnabled = true;
		// playBtn events
		_playBtn.onRollOver = Delegate.create (_this, playBtn_onRollOver);
		_playBtn.onRollOut = Delegate.create (_this, playBtn_onRollOut);
		_playBtn.onDragOver = Delegate.create (_this, playBtn_onRollOver);
		_playBtn.onDragOut = Delegate.create (_this, playBtn_onRollOut);
		_playBtn.onPress = Delegate.create (_this, playBtn_onPress);
		// volBtn events
		_volBtn.onPress = Delegate.create (_this, volBtn_onPress);
		_volBtn.onRelease = Delegate.create (_this, volBtn_onRelease);
		_volBtn.onReleaseOutside = Delegate.create (_this, volBtn_onRelease);
		_volBtn.onMouseMove = Delegate.create (_this, volBtn_onMouseMove);
		// buffbar events
		_buffBar.onPress = Delegate.create (_this, buffBar_onPress);
		_buffBar.onRelease = Delegate.create (_this, buffBar_onRelease);
		_buffBar.onReleaseOutside = Delegate.create (_this, buffBar_onRelease);
		_buffBar.onMouseMove = Delegate.create (_this, buffBar_onMouseMove);
		// key listener
		_keyListener = new Object ();
		_keyListener.onKeyDown = Delegate.create (_this, keyManager);
		Key.addListener (_keyListener);
	}
	
	//--------------------------------------------------------------------------------------------------------------
	// player init, events, controls
	private function onAppConfigured ():Void {
		App.debug.trace ("* initializing FLVPlayer");
		_this.init (App.FLV_URI);
	}

	private function onVideoComplete ():Void {
		App.debug.trace ("... FLV playback complete.");
		_movie.seekToPercent (0);
		onPauseFLVPlayer ();
	}

	/**
	 * load video and initialize FLVPlayer UI and FLVPlayer Core
	 * @param url (String) flv url
	 * @return Void
	 */
	public function init (url:String):Void {
		removeMovie ();
		_playBtn.gotoAndStop (1);
		_movie = new FLV ();
		_movie.onProgress = Delegate.create (_this, movie_onProgress);
		_movie.onEvent = Delegate.create (_this, movie_onEvent);
		_movie.load (url, _this.video, 320, 240, _this.audioContainer);
		_movie.playVideo ();
	}

	public function removeMovie ():Void {
		if (_movie) {
			_video._visible = false;
			_movie.stopVideo ();
			_movie.clean ();
			_movie = null;
			resetUI ();
		}
	}

	public function resetUI ():Void {
		_buffBar._xscale = 0;
		_progBar._xscale = 0;
		_playBtn.gotoAndStop (2);
		_video._visible = true;
	}
	
	// events for pausing from screen
	public function onPauseFLVPlayer ():Void {
		if (_movie) {
			_isKeyEnabled = false;
			_playBtn.gotoAndStop (2);
			_movie.pause ();
		}
	}
	
	public function onResumeFLVPlayer ():Void {
		if (_movie) {
			_isKeyEnabled = true;
			_playBtn.gotoAndStop (1);
			_movie.resume ();
		}
	}

	private function movie_onProgress (loadPercent:Number, currentTimePercent:Number):Void {
		var lp:Number = (loadPercent < 100) ? loadPercent : 100;
		var cp:Number = (currentTimePercent < 100) ? currentTimePercent : 100;
		_this._buffBar._xscale = lp;
		if (!_isSeeking) {
			_this._progBar._xscale = cp;
		} else {
			_movie.seekToPercent (_this._progBar._xscale);
		}
	}

	private function movie_onEvent (info:String):Void {
		switch (info) {
		case "bufferEmpty" :
			App.debug.trace ("movieEvent: bufferEmpty");
			break;
		case "bufferFull" :
			App.debug.trace ("movieEvent: bufferFull");
			break;
		case "bufferFlush" :
			App.debug.trace ("movieEvent: bufferFlush");
			break;
		case "start" :
			App.debug.trace ("movieEvent: start");
			break;
		case "stop" :
			App.debug.trace ("movieEvent: stop");
			//removeMovie ();
			App.bc.broadcast ("onVideoComplete");
			break;
		case "play_streamNotFound" :
			App.debug.trace ("movieEvent: play_streamNotFound");
			App.bc.broadcast ("onStreamNotFound");
			break;
		case "seek_InvalidTime" :
			App.debug.trace ("movieEvent: seek_invalidTime");
			_movie.rew ();
			break;
		case "seek_notify" :
			App.debug.trace ("movieEvent: seek_notify");
			break;
		default :
			App.debug.trace ("movieEvent: unrecognized onStatus value: " + info);
		}
	}

	private function pauseMemory () {
		_wasPlaying = _movie.isPaused ();
		_movie.pause ();
	}

	private function resumeMemory () {
		if (!_wasPlaying) {
			_movie.resume ();
		}
		_wasPlaying = null;
	}

	// volumeController
	private function setVolumeControl (p:Number):Void {
		// bust into orig/max/min check vars to help flash cope with quick keybound calls (bad flashplayer ... baaaddd)
		var ov:Number = (p) ? p : int (_volBtn._xmouse * 100 / _volBtn._width);
		var mv:Number = (ov >= 100) ? 100 : ov;
		var v:Number = (mv <= 0) ? 0 : mv;
		_volBtn.vbar._xscale = v;
		_movie.setVolume (v);
	}

	private function seek_ui ():Void {
		if (_this._isSeeking) {
			// use guttBar to prevent seek offset inaccuracy while still buffering
			var percent:Number = int ((_guttBar._xmouse - 2) * 100 / (_guttBar._width - 2));
			percent = (percent >= _buffBar._xscale) ? _buffBar._xscale - 1 : percent;
			percent = (percent <= 0) ? 1 : percent;
			percent = (percent >= 95) ? 95 : percent;
			_progBar._xscale = percent;
			//trace ("@seek_ui: " + percent + "% | bufferPercent: " + _buffBar._xscale + "% | bufferBar._xmouse=" + _buffBar._xmouse + " | buffBar._width: " + _buffBar._width);
		}
	}
	
	//--------------------------------------------------------------------------------------------------------------
	// ui event controllers
	private function keyManager ():Void {
		if (!App.KEY_ENABLE) {
			return;
		}
		if (Key.getCode () == Key.UP && _volBtn.vbar._xscale < 100) {
			var v:Number = int (_volBtn.vbar._xscale + 10);
			_this.setVolumeControl (v);
		}
		if (Key.getCode () == Key.DOWN && _volBtn.vbar._xscale > 0) {
			var v:Number = int (_volBtn.vbar._xscale - 10);
			_this.setVolumeControl (v);
		}
		if (Key.getCode () == Key.SPACE && _isKeyEnabled) {
			_this.playBtn_onPress ();
		}
	}

	private function buffBar_onPress ():Void {
		_isSeeking = true;
		seek_ui ();
		pauseMemory ();
	}

	private function buffBar_onRelease ():Void {
		_isSeeking = false;
		resumeMemory ();
	}

	private function buffBar_onMouseMove ():Void {
		seek_ui ();
	}
	
	private function playBtn_onPress ():Void {
		if (_movie) {
			if (_playBtn._currentframe == 1) {
				_playBtn.gotoAndStop (2);
				_movie.pause ();
			} else {
				_playBtn.gotoAndStop (1);
				_movie.resume ();
			}
		}
	}
	
	private function playBtn_onRollOver ():Void {
	}
	
	private function playBtn_onRollOut ():Void {
	}
	
	private function volBtn_onPress ():Void {
		_this._isDrag = true;
		_this.setVolumeControl ();
	}
	
	private function volBtn_onRelease ():Void {
		_this._isDrag = false;
	}
	
	private function volBtn_onMouseMove ():Void {
		if (_this._isDrag) {
			_this.setVolumeControl ();
		}
	}
}