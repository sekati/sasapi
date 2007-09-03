/**
 * com.sekati.log.SoapEvent
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.events.Event;
import com.sekati.service.SoapClient;
 
/**
 * SoapEvent object for use by {@link Logger} for {@link Console}.
 */
class com.sekati.service.SoapEvent extends Event {
	
	public static var onSoapConnectEVENT:String = "onSoapConnect";
	public static var onSoapLoadEVENT:String = "onSoapLoad";
	public static var onSoapDebugEVENT:String = "onSoapDebug";
	public static var onSoapFaultEVENT:String = "onSoapFault";
	//private static var _target:SoapClient = SoapClient.getInstance();
	
	/**
	 * Constructor creates a SoapEvent by {@link SoapClient} to be dispatched.
	 * @param type (String) - one of the Soap event types listed above.
	 * @param data (Object) - contains Soap transaction data for connect,load,debug,fault.
	 */
	public function SoapEvent (type:String, data:Object) {
		super(type, _target, data);
	}
}