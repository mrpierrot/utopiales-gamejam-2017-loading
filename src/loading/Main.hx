package loading;

import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.Lib;
import flash.ui.Mouse;

/**
 * ...
 * @author Pierre Chabiland
 */
class Main 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		Mouse.hide();
		stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
		//stage.addChild(new DebugInfos());
		var game:Game =  new Game(flash.Lib.current);
		
	}
	
}