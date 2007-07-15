/**
 * com.sekati.utils.ClassUtils
 * @version 2.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 /**
  * static class for linking 'extend MovieClip' type classes to MovieClips thru attachMovie, 
  * createEmptyMovieClip or MovieClip Instances on stage.<br/><br/>
  * 
  * An initObject param is available in all methods: {@link #createEmptyMovieClip}, {@link #attachMovie}
  * and {@link #attachClass}.  _depth is a custom initObject param which will set the clip to this depth 
  * regardless of method but *will not* store _depth as a MovieClip property; use getDepth if needed.
  *
  * {@code Example Class:
  * class com.sekati.Test extends MovieClip {
  * 	public function Test(){
  * 		trace("Test extends "+this._name);
  * 	}
  * }
  * }
  */
class com.sekati.utils.ClassUtils {
	/**
	 * create a movieclip with linked class (various init options)
	 * @param classRef (Function) reference to class to attach
	 * @param target (MovieClip) target scope to create MovieClip
	 * @param instanceName (String) created MovieClip instance name
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return MovieClip
	 * {@code Usage:
	 * var mc0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.Test, this, "mc0");
	 * var mc0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.Test, _root, "mc0", {_depth: 100, _x:25, _y:25});
	 * var mc0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.Test, this, "mc0", {_x:25, _y:25});
	 * }
	 */
	public static function createEmptyMovieClip (classRef:Function, target:MovieClip, instanceName:String, initObject:Object):MovieClip {
		var depth:Number = (!initObject._depth) ? target.getNextHighestDepth () : initObject._depth;
		var mc:MovieClip = target.createEmptyMovieClip (instanceName, depth);
		mc.__proto__ = classRef.prototype;
		if (initObject) {
			for (var i in initObject) {
				if (i != "_depth") {
					mc[i] = initObject[i];
				}
			}
		}
		classRef.apply (mc);
		return mc;
	}
	/**
	 * attach a MovieClip from library and extend with class (various init options)
	 * @param classRef (Function) reference to class to attach
	 * @param target (MovieClip) target scope to create MovieClip
	 * @param idName (String) linkage id for exported MovieClip in library	
	 * @param instanceName (String) created MovieClip instance name
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return MovieClip
	 * {@code Usage:
	 * var mc1:MovieClip = ClassUtils.attachMovie (com.sekati.Test, _root, "linkedMc", "mc1");
	 * var mc1:MovieClip = ClassUtils.attachMovie (com.sekati.Test, _root, "linkedMc", "mc1", {_x:50, _y:50});
	 * var mc1:MovieClip = ClassUtils.attachMovie (com.sekati.Test, _root, "linkedMc", "mc1", {_depth:200, _x:50, _y:50});
	 * }
	 */
	public static function attachMovie (classRef:Function, target:MovieClip, idName:String, instanceName:String, initObject:Object):MovieClip {
		var depth:Number = (!initObject._depth) ? target.getNextHighestDepth () : initObject._depth;
		var mc:MovieClip = target.attachMovie (idName, instanceName, depth, initObject);
		mc.__proto__ = classRef.prototype;
		if (mc._depth) {
			delete mc._depth;
		}
		classRef.apply (mc);
		return mc;
	}
	/**
	 * extend a MovieClip instance (on stage) with class (various init options)
	 * @param classRef (Function) reference to class to attach
	 * @param target (MovieClip) target scope to create MovieClip
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return MovieClip
	 * {@code Usage:
	 * var mc2:MovieClip = ClassUtils.attachClass (com.sekati.Test, mc2);
	 * var mc2:MovieClip = ClassUtils.attachClass (com.sekati.Test, _root.mc2, {_x:75, _y:75});
	 * var mc2:MovieClip = ClassUtils.attachClass (com.sekati.Test, mc2, {_depth:300, _x:75, _y:75});
	 * }
	 */
	public static function attachClass (classRef:Function, target:MovieClip, initObject:Object):MovieClip {
		var mc:MovieClip = target;
		mc.__proto__ = classRef.prototype;
		if (initObject) {
			for (var i in initObject) {
				if (i != "_depth") {
					mc[i] = initObject[i];
				} else {
					target.swapDepths (initObject[i]);
				}
			}
		}
		classRef.apply (mc);
		return target;
	}
	//
}
// eof
