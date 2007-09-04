/**
 * com.sekati.core.CoreObject
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.CoreInterface;
 import com.sekati.core.KeyFactory;
 import com.sekati.reflect.Stringifier;
 
/**
 * The core object for the SASAPI framework.
 */
class com.sekati.core.CoreObject extends Object implements CoreInterface {
	
	private var _this:CoreObject;
	
	public function CoreObject() {
		super();
		_this = this;
		KeyFactory.inject(this);
	}
	
	public function toString():String {
		return Stringifier.stringify(this);	
	}
	
	public function destroy():Void {
		for(var i in this){
			delete this[i];	
		}
		delete this;
	}
}