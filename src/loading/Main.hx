package loading;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

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
		var game:Game =  new Game(flash.Lib.current);
	}
	
}