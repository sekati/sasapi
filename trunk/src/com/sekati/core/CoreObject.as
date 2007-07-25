/**
 * com.sekati.core.CoreObject
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.KeyFactory;
 
/**
 * 
 */
class com.sekati.core.CoreObject {
	
	public function CoreObject() {
		KeyFactory.inject(this);
	}
}