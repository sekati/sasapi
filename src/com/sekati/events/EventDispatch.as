/**
 * com.sekati.events.EventDispatch
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import mx.events.EventDispatcher;

import com.sekati.events.Event;
import com.sekati.events.IEventDispatch;
/**
 * 
 * A centralized EventDispatcher to decouple event listeners & dispatchers from direct addressing
 * {@code Usage:
 * // listen for an event
 * EventDispatch.getInstance().addEventListener("testEvent", receiveObj);
 * receiveObj.testEvent = onEventReceived;
 * function onEventReceived(event:Object):Void {
 * var alertString:String = ("Event received - type: "+event.type+", target - "+event.target+", data:");
 * for (var i:String in event.data) alertString += " " + i + ": " + event.data[i] + ";";
 * trace(alertString);
 * }
 * // send an event
 * EventDispatch.getInstance().broadcast("testEvent",sendObj,{sender:sendObj, message:"hello", someNumber:42});
 * }
 * 
 * Some excellent explanations of the AS2/3 event models and broadcasters vs dispatchers
 * @see <a href="http://www.communitymx.com/content/article.cfm?page=1&cid=76FDB">http://www.communitymx.com/content/article.cfm?page=1&cid=76FDB</a>
 * @see <a href="http://www.kirupa.com/developer/actionscript/eventdispatcher.htm">http://www.kirupa.com/developer/actionscript/eventdispatcher.htm</a>
 */
class com.sekati.events.EventDispatch implements IEventDispatch {
	private static var _instance:EventDispatch;
	private var _manager:Object;
	/**
	* Singleton Accessor
	* @return EventDispatch
	*/
	public static function getInstance():EventDispatch {
		if (!_instance) {
			_instance = new EventDispatch();
		}
		return _instance;
	}
	/**
	 * shorthand singleton accessor getter
	 */
	 public function get $():EventDispatch {
	 	return EventDispatch.getInstance();	
	 }
	/**
	* Singleton Private Constructor: initializes centralized management of mx.events.EventDispatcher
	*/
	private function EventDispatch() {
		_manager = new Object ();
		EventDispatcher.initialize (_manager);
	}
	/**
	 * add the event listener to the centralized event manager
	 * @param event (String) the name of the event ("click", "change", etc)
	 * @param handler (Object) the function or object that should be called
	 * @return Void
	 */
	public function addEventListener(event:String, handler:Object):Void {
		_manager.addEventListener(event,handler);
	}
	/**
	   * remove the event listener from the centralized event manager
	   * @param event (String) the name of the event ("click", "change", etc)
	   * @param handler (Object) the function or object that should be called
	   * @return Void
	   */
	public function removeEventListener(event:String, handler:Object):Void {
		_manager.removeEventListener(event,handler);
	}
	/**
	  * dispatch the event to all listeners via the centralized event manager
	  * @param eventObj (Object) an Event or one of its subclasses describing the event
	  * @return Void
	  * {@code Usage:
	  * EventDispatch.getInstance().dispatchEvent({type:"myEvent", target:this, data:{foo:true, bar:false}});
	  * }
	  */
	public function dispatchEvent(eventObj:Object):Void {
		_manager.dispatchEvent(eventObj);
	}
	/**
	 * Bubbles event up the chain. The target property is added on the the route
	 * and then replaced by the new target.
	 * @param e (Event)
	 * @return Void
	 */
	public function bubbleEvent(e:Event):Void {
		e.bubble(this);
		dispatchEvent(e);
	}
	/**
	 * Create an Event object and dispatch it.
	 * {@code Usage:
	 * EventDispatch.getInstance().broadcast("myEvent",targetObject, {param0:value0, param1:value1, paramn:valuen});
	 * }
	 * @param _type (String) type of event
	 * @param _target (Object) the object that dispatched this event. There is a known bug with this property: It always comes back as a slash (/). This may be a flaw in EventDispatcher. If you need to pass the event source include it as a _data parameter.
	 * @param _data (Object) a transport object for any needed data
	 * @return Void
	 */
	public function broadcast(_type:String, _target:Object, _data:Object):Void {
 		var event:Object = {type:_type, target:_target, data:_data};
 		_manager.dispatchEvent(event);
	}
	//
}
// eof