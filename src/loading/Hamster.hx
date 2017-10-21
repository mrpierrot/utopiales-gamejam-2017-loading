package loading;
import haxe.ds.ObjectMap;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.engines.pathfinding.AStar;
import jammer.engines.physics.PathUnit;
import jammer.process.Cooldown;
import jammer.utils.DungeonGeneratorUtils;
import jammer.utils.MathUtils;

/**
 * ...
 * @author Pierre Chabiland
 */
class Hamster extends PathUnit
{
	public static var _id:Int = 0;
	public var cd:Cooldown;
	public var id:Int;
	public var anim:JamAnimation;
	
	public static inline var SHOCKED_DURATION : Int = Std.int(Assets.FPS * 2);
	public static inline var SHOCKED_COMPLETED : Int = Std.int(Assets.FPS * 2) + 1;
	public var maxLife:Float;
	public var maxWorkDuration:Int;
	public var minWorkDuration:Int;
	
	
	public function new() 
	{
		cd = new Cooldown(0, "hamster_" + id);
		id = _id++;
		super(AssetsManager.instance.createAnimation("hamster"));
		
		anim = cast((skin), JamAnimation);
		
		
		
		anim.state = "idle";
		anim.centerX = 16;
		anim.centerY = 13;
		  
        anim.registerStateCondition("runRight", function() : Bool
                {
                    return (dirX > 0 || (dirY != 0 && lastDirX > 0));
                });
        
        anim.registerStateCondition("runLeft", function() : Bool
                {
                    return (dirX < 0 || (dirY != 0 && lastDirX < 0));
                });
				
		anim.registerStateCondition("work", function() : Bool
                {
                    return cd.has("worked");
                });
				
		anim.registerStateCondition("shocked", function() : Bool
                {
                    return cd.has("shocked");
                });
        
        anim.registerStateCondition("idle", function() : Bool
                {
                    return (dirX == 0 && dirY == 0);
                });
				
		
	}
	
	 override public function reset() : Void
    {
        super.reset();
        xrMin = xrMin2 = 0.3;
        xrMax = xrMax2 = 0.7;
        yrMin = yrMin2 = 0;
        yrMax = yrMax2 = 0.8;
        xr = yr = 0.5;
        //speed *= 0.7;
        speed *= 1;
        //speed *= 2;
        collisionEnabled = true;
        repulseEnabled = true;
        repulseForce /= 1;
        targetMode = false;
        radius = 9;
        gravity = 0;

		maxLife = 20;
		life = maxLife;
		
		minWorkDuration = Std.int(Assets.FPS * 8);
		maxWorkDuration = Std.int(Assets.FPS * 16);
		trace(minWorkDuration, maxWorkDuration);
		cd.add("worked", MathUtils.irnd(minWorkDuration, maxWorkDuration), function():Void{
			trace("go away");
		});		
    }
	
	
	public function shocked() : Void {
		cd.add("shocked",SHOCKED_DURATION);
		cd.add("shocked_after",SHOCKED_COMPLETED);
	}
	
	inline override public function execute(pDelta : Float = 1.0) : Void
    {
		super.execute(pDelta);
    }
	
	inline public function action(workbenchs:Array<Workbench>) : Void {
		if (!cd.has("shocked") && cd.has("shocked_after")){
			
		}
	}
	
	public inline function goto(end:Cell):Void{
		var start:Cell = level.getCell(this.cx, this.cy);
		var result:ObjectMap<Dynamic,Dynamic> = AStar.search(start, end, getNeighborsCells, DungeonGeneratorUtils.getCellsHeuristic, DungeonGeneratorUtils.getCellsHeuristic);
		var current : Cell = start;
		var next : Cell;
		this.clearPath();
		do
		{
			//_log("result : ",current);
			next = result.get(current);
			if (next != null)
			{
				//trace(next);
				this.addPathPoint(next.cx, next.cy);
			}
			current = next;
		}
		while (current != null);
	}
	
	var neightbors : Array<Cell> = new Array<Cell>();
	
	override public function pathCompleted():Void 
	{
		super.pathCompleted();
		//trace("pathCompleted");
		//var cells:Array<Cell> = Random.shuffle(getNeighborsCells(level.getCell(this.cx, this.cy)));
		//var cells:Array<Cell> = getNeighborsCells(level.getCell(this.cx, this.cy));

	}
	
	function getNeighborsCells(pCurrent : Cell) : Array<Cell>
	{
		neightbors.splice(0, neightbors.length);
		var neightbor : Cell;
		neightbor = level.getCell(pCurrent.cx, pCurrent.cy + 1);
		if (neightbor != null && !neightbor.collide) neightbors.push(neightbor);
		neightbor = level.getCell(pCurrent.cx+1, pCurrent.cy);
		if (neightbor != null && !neightbor.collide) neightbors.push(neightbor);
		neightbor = level.getCell(pCurrent.cx, pCurrent.cy - 1);
		if (neightbor != null && !neightbor.collide) neightbors.push(neightbor);
		neightbor = level.getCell(pCurrent.cx-1, pCurrent.cy);
		if (neightbor != null && !neightbor.collide) neightbors.push(neightbor);
		
		return neightbors;
	}
	
}