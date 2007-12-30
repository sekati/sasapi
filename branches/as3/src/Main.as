/** * com.sekati.core.Main * @version 1.0.2 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */package {	import com.sekati.display.TopLevelDisplay;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		import flash.display.StageQuality;	import flash.system.fscommand;		import flash.system.Security;	import caurina.transitions.properties.*;		/**	 * Main	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/	 * @see http://code.google.com/p/sasapi/	 */	public class Main extends TopLevelDisplay {				public function Main() {			trace( "*** - Document Initialized ..." );			super( );			setMovieProps( );			initTweenEngine( );			buildCompositions( );		}		/**		 * General document setup		 * @return void		 */		private function setMovieProps():void {			trace( "*** Setting Movie Properties ..." );			Security.allowDomain( "*" );			Security.allowInsecureDomain( "*" );			fscommand( "swLiveConnect", "true" );			fscommand( "allowscale", "false" );			fscommand( "showmenu", "false" );			fscommand( "fullscreen", "false" );			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.quality = StageQuality.HIGH;			stage.stageFocusRect = false;		}		/**		 * Initialize Tweener specialProperties shortcuts		 * @note comment out shortcuts which your project does not require.		 * @see http://hosted.zeh.com.br/tweener/docs/en-us/		 * @return void		 */		private function initTweenEngine():void {			trace( "*** Initializing Tween Engine ..." );			FilterShortcuts.init( );			ColorShortcuts.init( );			DisplayShortcuts.init( );			TextShortcuts.init( );			SoundShortcuts.init( );								}		/**		 * Centralize class compositions for core functionalities (bootstraps, managers, etc)		 * @return void		 */			private function buildCompositions():void {			trace( "*** Building Compositions ..." );		}	}}