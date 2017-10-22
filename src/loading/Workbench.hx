package loading;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.types.JamDisplayObject;
import jammer.engines.level.Cell;
import jammer.engines.physics.Entity;
import jammer.utils.MathUtils;

/**
 * ...
 * @author Pierre Chabiland
 */
class Workbench
{

	public var worker:Hamster;
	public var skin:JamDisplayObject;
	public var cell:Cell;
	
	public function new() 
	{
		skin = AssetsManager.instance.createSprite("workbench"+MathUtils.irnd(1,3));
	}
	
	public function setCellPosition(pCell:Cell):Void 
	{

		skin.x = pCell.cx * pCell.level.tileWidth;
		skin.y = pCell.cy * pCell.level.tileHeight;
	}
	
}