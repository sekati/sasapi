/**
 * com.sekati.ui.ContextualMenu
 * @version 1.7.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Context Menu management for right clicks!
 * {@code Usage:
 * 	var cm:ContextualMenu = new ContextualMenu(_level0);
 * 	cm.addItem("Item One", Delegate.create(this, myFunction), true, true);
 * 	cm.addItem("Item Two");
 * 	cm.editItem("Item Two", "Item 2");
 * 	cm.removeItem("Item One"); // remove the first item
 * 	cm.enabled = false; // disable this menu
 * }
 */
class com.sekati.ui.ContextualMenu {
	
	private var _target:MovieClip;
	private var _isEnabled:Boolean;
	private var _hasBuiltInItems:Boolean;
	private var _items:Array;
	private var _backup:Array;

	/**
	 * Custom Context Menu Constructor
	 * @param target (MovieClip) object context menu should exist on
	 * @return Void
	 * @throws Error if no target is provided and returns without proper instantiation.
	 */	
	public function ContextualMenu(target:MovieClip) {
		if(!target) {
			throw new Error ("@@@ com.sekati.ui.ContextualMenu Error: constructor expects a 'target:MovieClip' parameter.");
			return;	
		}
		_target = target;
		_isEnabled = true;
		_hasBuiltInItems = false;
		_items = new Array();
		_backup = new Array();
	}
	
	/**
	 * Add an item to the Context Menu
	 * @param caption (String) menu item text
	 * @param cb (Function) delegated callback function [optional]
	 * @param isDiv (Boolean) add a divider before the item [optional, default: true]
	 * @param isEnabled (Boolean) item is enabled for selection [optional, default: true]
	 * @return Void
	 */	 
	public function addItem(caption:String, cb:Function, isDiv:Boolean, isEnabled:Boolean):Void {
		cb = (!cb) ? menuClick : cb;
		isDiv = (isDiv == undefined) ? true : isDiv;
		isEnabled = (isEnabled == undefined) ? true : isEnabled;
		_items.push({_caption:caption, _cb:cb, _isDiv:isDiv, _isEnabled:isEnabled});
		buildMenu();
	}

	public function addToggleItem(captions:Array, cb:Array, isDiv:Boolean, isEnabled:Boolean):Void {
			
	}
	
	/**
	 * Edit an added item in the Context Menu
	 * @param oldCaption (String) previous menu item text
	 * @param newCaption (String) new menu item text
	 * @param cb (Function) delegated callback function [optional, default: previous setting]
	 * @param isDiv (Boolean) add a divider before the item [optional, default: previous setting]
	 * @param isEnabled (Boolean) item is enabled for selection [optional, default: previous setting]
	 * @return Boolean - true if item was successfully found and changed, false if edit failed.
	 */
	public function editItem(oldCaption:String, newCaption:String, cb:Function, isDiv:Boolean, isEnabled:Boolean):Boolean {
		var prevItem:Object, newItem:Object;
		for(var i:Number=0; i< _items.length; i++){
			if (_items[i]._caption === oldCaption) {
				prevItem = _items[i];
				var newCb:Function = (!cb) ? prevItem._cb : cb;
				var newDiv:Boolean = (!isDiv) ? prevItem._isDiv : isDiv;
				var newEnabled:Boolean = (!isEnabled) ? true : false;
				newItem = {_caption:newCaption, _cb:newCb, _isDiv:newDiv, _isEnabled:newEnabled};
				_items[i] = newItem;
				buildMenu ();
				return true;
			}			
		}
		return false;	
	}
	
	public function disableItem (name:String):Void {
		var item = getItem("_caption", name);
		if(item == null) return;
		item._isEnabled = false;
		buildMenu ();
	}
	public function enableItem (name:String):Void {
		var item = getItem("_caption", name);
		if(item == null) return;
		item._isEnabled = true;
		buildMenu ();		
	}

	/**
	 * Remove an item from the Context Menu
	 * @param name (String) the caption name of the item to be removed
	 * @return Boolean - true if item was sucessfully removed, false if removal failed.
	 */
	public function removeItem (name:String):Boolean {
		var itemIndex:Number = getItemIndex ("_caption", name);
		if (itemIndex != null) {
				_items.splice(itemIndex, 1);
				buildMenu ();
				return true;
		}
		
		return false;
	}

	/**
	 * Get an item object from the _items menu array if it exists
	 * @param name (String) item name
	 * @return Object - item object if found, else null.
	 */
	private function getItem (name:String):Object {
		var item = getItemIndex ("_caption", name);
		if (item != null) {
			return _items[item];	
		} else {
			return null;
		}
	}
	
	/**
	 * Locate an item's index in the _items menu array by property value.
	 * @param prop (String) item property to search by [e.g. "_caption"]
	 * @param val (Object) unique item value to match with
	 * @return Number - item array index if found, else null
	 */
	private function getItemIndex (prop:String, val:Object):Number {
		for(var i:Number=0; i< _items.length; i++){
			if(_items[i][prop] === val) {
				return i;
			}
		}
		return null;
	}		
	
	/**
	 * Build the custom Context Menu.
	 * @return Void
	 */	
	private function buildMenu():Void {
		var m:ContextMenu = new ContextMenu ();
		if(!_hasBuiltInItems) {
			m.hideBuiltInItems ();
		}
		for(var i:Number=0; i<_items.length; i++) {
			var cmi:ContextMenuItem = new ContextMenuItem (_items[i]._caption, _items[i]._cb, _items[i]._isDiv, _items[i]._isEnabled);
			m.customItems.push(cmi);
		}
		_target.menu = m;
	}
	
	/**
	 * Menu enabled setter
	 * @param b (Boolean) - enable (true) or disable (false) the custom Context Menu [default: true].
	 * @return Void
	 */
	public function set enabled(b:Boolean):Void {
		if (b == false) {
			if (_isEnabled != false) {
				_isEnabled = false;
				_backup = _items;
				_items = [];
				buildMenu ();
			}
		} else {
			if (_isEnabled != true) {
				_isEnabled = true;
				_items = _backup;
				buildMenu ();
			}
		}
	}
	
	/**
	 * Menu enabled getter
	 * @return Boolean
	 */
	public function get enabled():Boolean {
		return _isEnabled;	
	}	
	
	/**
	 * Menu builtInItems setter
	 * @param b (Boolean) - enable (true) or disable (false) the Context Menu's built in items [default: false].
	 * @return Void
	 */
	public function set builtInItems(b:Boolean):Void {
		_hasBuiltInItems = b;	
	}
	
	/**
	 * Menu builtInItems getter
	 * @return Boolean
	 */
	public function get builtInItems():Boolean {
		return _hasBuiltInItems;	
	}
	
	/**
	 * Void function to assign to items added without callback
	 * @return Void
	 */
	public function menuClick ():Void {
	}
}