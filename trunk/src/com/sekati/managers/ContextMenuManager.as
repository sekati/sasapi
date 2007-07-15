/**
 * com.sekati.managers.ContextMenuManager
 * @version 1.5.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.core.App;
/**
 * ContextMenu management for right clicks!
 */
class com.sekati.managers.ContextMenuManager {
	public function ContextMenuManager (uri:String) {
		var _menu:ContextMenu = new ContextMenu ();
		var _item0:ContextMenuItem = new ContextMenuItem (App.APP_NAME, onItemClick, true, true);
		_menu.hideBuiltInItems ();
		_menu.customItems.push (_item0);
		_root.menu = _menu;
	}
	public function onItemClick ():Void {
		// do somethin!
	}
	//
}
// eof
