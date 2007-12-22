/** * com.sekati.display.BitmapImageSliceClip * @version 1.0.1 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */import com.sekati.core.App;import com.sekati.display.IBitmapImageClip;import com.sekati.display.BaseClip;import com.sekati.utils.Delegate;import com.sekati.utils.MovieClipUtils;import com.sekati.except.FatalException;import flash.display.BitmapData;import flash.geom.ColorTransform;import flash.geom.Matrix;import flash.geom.Rectangle;/** * BitmapImageSliceClip - load a large image, convert it to a set of smoothed BitmapData objects available  * for manipulation.This works around the BitmapDataObject 2880 pixel width or height limitation. * NOTE: The clip image is automatically hidden (_alpha:0) until manually tweened in by developer. *  * {@code Usage: * 	import com.sekati.utils.* * 	import caurina.transitions.Tweener; * 	 * 	function _onProgress(l:Number, t:Number):Void { trace("img_onProgress: "+l+" / "+t); } * 	function _onInit():Void { Tweener.addTween(image, {_alpha:100, time:0.3, transition:"easeInOutQuint"}); } * 	function _onError(code:String):Void { trace("oh noes! The image couldnt be loaded: "+ecode); } * 	 * 	// create an empty BitmapImageClip * 	var image:MovieClip =  ClassUtils.createEmptyMovieClip (com.sekati.display.BitmapImageSliceClip, this, "image", {_x:0, _y:0}); * 	 * 	// load an image and define onProgress onInit Delegates. * 	image.load("test.jpg", Delegate.create(this, _onInit), Delegate.create(this, _onProgress), Delegate.create(this, _onError)); * } */class com.sekati.display.BitmapImageSliceClip extends BaseClip implements IBitmapImageClip {	public var img:MovieClip;	public var bmp:Array;	private var _uri:String;	private var _smooth:Boolean;	private var _progressCb:Function;	private var _initCb:Function;	private var _errorCb:Function;	private var _loader:MovieClipLoader;	private var _tmp:MovieClip;	/**	 * Constructor	 */	public function BitmapImageSliceClip() {		super( );		_loader = new MovieClipLoader( );		_this.onLoadInit = Delegate.create( _this, _onInit );		_this.onLoadError = Delegate.create( _this, _onError );		_this.onLoadProgress = Delegate.create( _this, _onProgress );		_loader.addListener( _this );	}	/**	 * Load image and convert to bitmap	 * @param uri (String)	 * @param isSmoothed (Boolean) - enable smoothing on the bitmap.	 * @param onInit (Function) - cb when image is loaded, converted, ready for use.	 * @param onProgress (Function) - cb is passed args: bytesLoaded, bytesTotal.	 * @param onError (Function) - cb is passed arg errorCode, httpStatus.	 * @return Void	 */	public function load(uri:String, isSmoothed:Boolean, onInit:Function, onProgress:Function, onError:Function):Void {		_uri = uri;		_smooth = isSmoothed;		_progressCb = onProgress;		_initCb = onInit;		_errorCb = onError;		createContainers( );		_loader.loadClip( _uri, _tmp );		}	/**	 * Remove the bitmap and clips.	 * @return Void	 */	public function unload():Void {		_loader.unloadClip( img );		bmp.dispose( );		MovieClipUtils.rmClip( _tmp ); 		MovieClipUtils.rmClip( img );	}	/**	 * Create the temporary image Container	 * @return Void	 */	private function createContainers():Void {		if (bmp.length > 0) {			for (var i:Number = 0; i < bmp.length ; i++) bmp[i].dispose( );		}		if (_tmp) MovieClipUtils.rmClip( _tmp ); 		if (img) MovieClipUtils.rmClip( img );		img = _this.createEmptyMovieClip( "img", _this.getNextHighestDepth( ) );		_tmp = _this.createEmptyMovieClip( "_tmp", _this.getNextHighestDepth( ) );		bmp = new Array( );		//img.cacheAsBitmap = true;		_tmp._visible = false;		_this._alpha = 0;	}	/**	 * Clear existing callbacks in preparation for another load	 * @return Void	 */	private function clearCallbacks():Void {		_initCb = undefined;		_progressCb = undefined;		_errorCb = undefined;			}	/**	 * Once external image is loaded, convert to smoothed bitmapData object	 * and run the {@link _initCb} if it was defined during {@link load}.	 * @return Void	 */	private function _onInit():Void {		var sw:Number = _tmp._width;		var sh:Number = _tmp._height;		var sliceWidth:Number = 2000;		var slices:Number = Math.ceil( sw / sliceWidth );		var rect:Rectangle = new Rectangle( 0, 0, sliceWidth, sh );		var ct:ColorTransform = new ColorTransform( );				App.log.info( "foo", "### Source Image (" + sw + "x" + sh + ") results in: " + slices + " slices @ " + sliceWidth + " px/slice (including overflow)" );				// draw,attach,place each column		for (var i:Number = 0; i < slices ; i++) {			var xslice:Number = sliceWidth * i;			var diff:Number = 0;			if (i == (slices - 1) && (xslice + sliceWidth) > _tmp._width) {				App.log.warn( _this, "!!! BITMAP:IMAGE -> BUFFER OVERFLOW !!!" );				diff = sliceWidth - (_tmp._width - xslice);				rect = new Rectangle( 0, 0, sliceWidth - diff, sh );				App.log.info( _this, "Adjusting for overflow: New sliceWidth: " + (sliceWidth - diff) );			}			var b:BitmapData = new BitmapData( (sliceWidth - diff), sh, true, 0x00FFFFFF );				var m:Matrix = new Matrix( );			m.translate( -i * sliceWidth, 0 );			b.draw( _tmp, m, ct, "normal", rect, true );				var container:MovieClip = img.createEmptyMovieClip( "bmp" + i, img.getNextHighestDepth( ) );			container.attachBitmap( b, container.getNextHighestDepth( ), "auto", _smooth );			container._x = xslice;			bmp.push( b );			App.log.info( _this, "Attaching bitmapData slice: " + i + " (" + container + "._x:" + container._x + ") slice section: " + xslice + " - " + (xslice + sliceWidth - diff) );			}				App.log.status( _this, ":Bitmap:Image slice assembly completed successfully: " + img._width + "x" + img._height );				MovieClipUtils.rmClip( _tmp );		_initCb( );		clearCallbacks( );	}	/**	 * Call the onProgress cb 	 * @param target (MovieClip)	 * @param bytesLoaded (Number)	 * @param bytesTotal (Number)	 * @return Void	 */	private function _onProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {		//trace("loading: "+target + " " + bytesLoaded + "/" + bytesTotal);		_progressCb( bytesLoaded, bytesTotal );	}	/**	 * Call the onError cb	 * @param errorCode (String)	 * @param httpStatus (String)	 */	private function _onError(target_mc:MovieClip, errorCode:String, httpStatus:Number):Void {		_errorCb( errorCode, httpStatus );		clearCallbacks( );		throw new FatalException( _this, "Could not load image from url:" + _uri, arguments );	}}