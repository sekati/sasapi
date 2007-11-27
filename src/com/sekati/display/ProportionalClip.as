/** * com.sekati.display.ProportionalClip * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ import com.sekati.display.LiquidClip; import com.sekati.utils.AlignUtils;/** * ProportionalClip */class com.sekati.display.ProportionalClip extends LiquidClip {	private var _liquid:MovieClip;	public function ProportionalClip() {		super();		_liquid = _this;	}		/**	 * proportionally scale and position the clip contents	 */	public function _onResize():Void {		trace("RE");		AlignUtils.scaleRatio(_liquid, Stage.width, Stage.height);		//AlignUtils.scaleToFit(_liquid, Stage.width, Stage.height, true);		/*		// find center		var mx:Number = Stage.width/2;		var my:Number = Stage.height/2;				// reposition to middle		_liquid._x = mx;		_liquid._y = my;				// scale background to fit width and height		_liquid._width = Stage.width;		_liquid._height = Stage.height;				*/		// see if it grew bigger horizontally or vertically and adjust other to match to maintain aspect ratio		//(_liquid._xscale >  _liquid._yscale) ? _liquid._yscale = _liquid._xscale : _liquid._xscale = _liquid._yscale;		// or:		//_liquid._xscale = _liquid._yscale = Math.max(_liquid._xscale, _liquid._yscale);	}	}