/**
 * com.sekati.display.MultiLanguageTextField
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.utils.ArrayUtils;
import com.sekati.utils.ClassUtils;
import com.sekati.validate.StringValidation; 
 
/**
 * Support for Multi-Language TextFields via ISO 639 short language names.
 * @see {@link http://en.wikipedia.org/wiki/ISO_639}
 */
class com.sekati.display.MultiLanguageTextField extends TextField {
	
	private var _langType:Array;
	private var _langContent:Array;
	private var _lang:Number;
	
	/**
	 * MultiLanguageTextField Constructor
	 */
	public function MultiLanguageTextField() {
		_langType = new Array("en","ch","de","es","it","ja","no","se");
		_lang = 0;
	}
	
	/**
	 * Language getter/setter 
	 */
	public function set lang (l:Number):Boolean {
		_lang = l;
		if(!StringValidation.isBlank(_langContent[l])) {
			this.text = _langContent[_lang] = str;
		}
		return true;
	}
	public function get lang ():String {
		return _langType[_lang];
	}
	
	/**
	 * text getter / setter
	 */
	public function set text(str:String):Void {
		super();
		_langContent[_lang] = str;			
	}
	
	public function get text():String {
		return _langContent[_lang];
	}
}