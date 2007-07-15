/**
* @class com.sekati.ui.ImageBox
* @author jason m horwitz // sekati.com
* @version 1.0.0
* @description imageBox
*/
import com.sekati.core.App;
import com.sekati.utils.Delegate;
import com.sekati.display.CoreClip;
//
class com.sekati.ui.ImageBox extends MovieClip {
	// refs
	public var _this:MovieClip;
	public var _img:MovieClip;
	public var _btn0:MovieClip;
	public var _btn1:MovieClip;
	public var _btn2:MovieClip;
	//
	// constructor
	private function ImageBox () {
	}
	public function configUI ():Void {
		// refs
		_img = _this.img;
		_btn0 = _this.btn0;
		_btn1 = _this.btn1;
		_btn2 = _this.btn2;
		//
		// setup
		App.bc.subscribe (_this);
		//
		// button setup and events
		_btn0.tf.text = "image 1";
		_btn1.tf.text = "image 2";
		_btn2.tf.text = "image 3";
		_btn0.onRelease = Delegate.create (_this, btn0_onRelease);
		_btn1.onRelease = Delegate.create (_this, btn1_onRelease);
		_btn2.onRelease = Delegate.create (_this, btn2_onRelease);
	}
	private function onAppConfigured ():Void {
		App.debug.trace ("* initializing ImageBox");
		btn0_onRelease ();
	}
	//
	private function btn0_onRelease ():Void {
		_img.load (App.IMG1, 300, 225, 0x333333, 0x666666, 75, true);
	}
	private function btn1_onRelease ():Void {
		_img.load (App.IMG2, 300, 225, 0xFF00FF, 0xFFCCFF, 75, true);
	}
	private function btn2_onRelease ():Void {
		_img.load (App.IMG3, 300, 225, 0xFFFF00, 0xFF9900, 75, true);
	}
	//
}
// EOF
