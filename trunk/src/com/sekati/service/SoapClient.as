/**
 * com.sekati.service.SoapClient
 * @version 0.3.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import mx.services.SOAPCall;
import mx.services.WebService;

/**
 * Soap Client class to be used with <a href="http://consume.sekati.com/?sid=swsdk">JNuSOAP</a>.<br>
 * 
 * <br>Q: 'There are multiple possible ports in the WSDL file; please specify a service name and port name!?'
 * <br>A: add port to class instance, seach for "port" in the wsdl & see url's below for more info.
 * 
 * @see <a href="http://www.intangibleinc.com/movabletype/archives/000007.html">http://www.intangibleinc.com/movabletype/archives/000007.html</a>
 * @see <a href="http://livedocs.macromedia.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000796.html">http://livedocs.macromedia.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000796.html</a>
 * @see <a href="http://www.flash-db.com/Tutorials/lclasses/lclasses.php?page=2">http://www.flash-db.com/Tutorials/lclasses/lclasses.php?page=2</a>
 * @see <a href="http://www.adobe.com/devnet/flash/articles/flmxpro_webservices_03.html">http://www.adobe.com/devnet/flash/articles/flmxpro_webservices_03.html</a>
 */
class com.sekati.service.SoapClient extends CoreObject {

	private static var _instance:SoapClient;
	
	private var _ws:WebService;
	private var _wsdl:String;
	private var debugFn:Function;

	/**
	 * Constructor
	 * @param wsdl (String) wsdl url
	 * @param port (String) optional service port
	 * @param debugHandler (Function) debug function
	 * @param loadFn (Function) service onLoad handler
	 * @param faultFn (Function) service onFault handler
	 * @return Void
	 */
	public function SoapClient(wsdl:String, port:String, debugHandler:Function, loadFn:Function, faultFn:Function) {
		// set passed wsdl to class
		_wsdl = wsdl;
		// set passed debug function to class
		debugFn = debugHandler;
		// throw instatiation notice
		debugFn("SoapClient Initialized ...\n");
		// attempt webservice connection
		wsConnect(loadFn, faultFn, port);
	}
	
	private function wsConnect(loadFn:Function, faultFn:Function, port:String):Void {
		// instantiate new webservice
		_ws = new WebService(_wsdl);
		// added re http://www.adobe.com/devnet/flash/articles/flmxpro_webservices_03.html
		if (port) {
			_ws._portName = port;
		}
		// alias debug function to prevent scope issue else onLoad/onFault events call debugFn as ws method 
		_ws.debugFn = debugFn;
		// webservice load handler
		_ws.onLoad = function(wsdl:String):Void  {
			debugFn("@@@@@ WEBSERVICE LOADING / PARSING WSDL @@@@@\n"+wsdl+"\n");
			loadFn();
		};
		// webservice fault handler
		_ws.onFault = function(fault:Object):Void  {
			debugFn("##### WEBSERVICE FAULTING #####");
			debugFn("fault.faultstring: "+fault.faultstring);
			debugFn("fault.faultcode: "+fault.faultcode);
			debugFn("fault.detail: "+fault.detail);
			debugFn("fault.faultactor: "+fault.faultactor);
			faultFn();
		};
	}
	
	/**
	 * webservice method call
	 * @param method (String) service method name
	 * @param args (Array) array of service method arguments
	 * @param resultFn (Function) onResult handler
	 * @param faultFn (Function) onFault handler
	 * @return Void
	 */
	public function wsCall(method:String, args:Array, resultFn:Function, faultFn:Function):Void {
		// Call Remote WebService Method using args array; then call defined resultFn or FaultFn 
		// NOTE: webservice method invocations return an asynchronous callback. 
		// callback is undefined if the service itself is not created (and service.onFault fires)
		var cb:Function = _ws[method].apply(_ws, args);
		// alias debug function for handler to prevent scope issue else onResult/onFault events call debugFn as ws method
		cb.debugFn = debugFn;
		// call load handler
		cb.onResult = function(result):Void  {
			// receive SOAP output, which in is deserialized as a struct (ActionScript object)
			debugFn("@@@@@ CALL RESULT @@@@@");
			debugFn(result);
			// debug request & response xml objects
			debugFn("SOAP REQUEST ENVELOPE: "+cb.request+"\n");
			debugFn("SOAP RESPONSE ENVELOPE: "+cb.response+"\n");
			// debug myCall properties and info
			for (var i in this.myCall) {
				debugFn("MyCall SoapCall Properties: "+i+"  "+this.myCall[i]);
			}
			for (var i in SOAPCall) {
				debugFn("SOAPCall-> "+i+" "+SOAPCall[i]);
			}
			//SOAPCall.doDecoding
			debugFn("\n");
			resultFn(result);
		};
		// call fault handler
		cb.onFault = function(fault):Void  {
			// catch SOAP fault and handle it according to this app's requirements
			debugFn("##### CALL FAULT #####");
			debugFn("fault.faultstring: "+fault.faultstring);
			debugFn("fault.faultcode: "+fault.faultcode);
			debugFn("fault.detail: "+fault.detail);
			debugFn("fault.faultactor: "+fault.faultactor);
			debugFn("REQUEST: "+cb.request);
			debugFn("SOAP RESPONSE ENVELOPE: "+cb.response);
			faultFn(fault);
		};
	}	
}