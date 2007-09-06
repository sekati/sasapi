/**
 * com.sekati.core.Bootstrap
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.core.CoreObject;
 
/**
 * Handle the Application Bootstrapping process.
 */
class com.sekati.core.Bootstrap extends CoreObject {
	
	private static var _instance:Bootstrap;
	
	/**
	 * Singleton Private Constructor
	 */
	private function Bootstrap () {
		super();
	}
	
	/**
	 * Singleton Accessor
	 * @return Bootstrap
	 */
	public static function getInstance ():Bootstrap {
		if (!_instance) {
			_instance = new Bootstrap ();
		}
		return _instance;
	}

	/**
	 * Shorthand singleton accessor getter
	 * @return Bootstrap
	 */
	 public static function get $():Bootstrap {
	 	return Bootstrap.getInstance();	
	 }	
	
}