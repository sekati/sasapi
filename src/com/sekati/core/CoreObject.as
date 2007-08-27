/**
 * com.sekati.core.CoreObject
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreInterface;
import com.sekati.core.KeyFactory;
 
/**
 * The basic object for the SASAPI framework.
 */
class com.sekati.core.CoreObject extends Object implements CoreInterface {
	
	public function CoreObject() {
		super();
		KeyFactory.inject(this);
	}
	
	public function toString():String {
		return String(this);	
	}
	
	public function destroy():Void {
		for(var i in this){
			delete this[i];	
		}
		delete this;
	}
}