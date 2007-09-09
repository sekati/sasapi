/**
 * com.sekati.except.Catcher
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.except.Exception;
 import com.sekati.validate.TypeValidation;
 
/**
 * Generic {@link Exception} catch handler.
 */
class com.sekati.except.Catcher {
	
	/**
	 * A generic Exception handler that returns string data about the Exception for logging or tracing.
	 * @param e (Exception)
	 * @return String
	 */
	public static function handle (e:Exception):String {
		var a:Array = e.getStack();
		var tmp:String = "[ ";
		for(var i:Number = 0; i<a.length; i++) tmp += a[i]+" ("+TypeValidation.getType(a[i]).name+"), ";	
		var stack:String = tmp.slice(0,tmp.length-2)+" ]";
		var str:String = "%%% Catcher handling Exception:\nName: '"+ e.getName()+"'\nType: '"+e.getType()+"'\nErrorCode: '"+e.getErrorCode()+"'\nThrower: "+e.getThrower()+"\nStack: "+ stack +"\n\n";
		return str;
	}
	
	private function Catcher(){
	}
}