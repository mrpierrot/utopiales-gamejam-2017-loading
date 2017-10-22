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

	public var maxLife:Float;
	public var maxWorkDuration:Int;
	public var minWorkDuration:Int;
	public var workbenchs:Array<Workbench>;
	public var currentWorkbench:Workbench;
	public var state:String;
	
	
	public function new(pWorkbenchs:Array<Workbench>) 
	{
		cd = new Cooldown(0, "hamster_" + id);
		id = _id++;
		super(AssetsManager.instance.createAnimation("hamster"));
		
		this.workbenchs = pWorkbenchs;
		
		
		anim = cast((skin), JamAnimation);
		
		
		
		anim.state = "idle";
		anim.centerX = 16;
		anim.centerY = 16;
		  
        anim.registerStateCondition("runRight", function() : Bool
                {
                    return (dirX > 0 || (dirY != 0 && lastDirX > 0));
                });
        
        anim.registerStateCondition("runLeft", function() : Bool
                {
                    return (dirX < 0 || (dirY != 0 && lastDirX < 0));
                });
				
		anim.registerStateCondition("shocked", function() : Bool
                {
                    return cd.has("shocked");
                });
				
		anim.registerStateCondition("work", function() : Bool
                {
                    return cd.has("worked");
                });
				
        
        anim.registerStateCondition("idle", function() : Bool
                {
                    return (dirX == 0 && dirY == 0);
                });
				
		state = "idle";
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
        radius = 16;
        gravity = 0;

		maxLife = 20;
		life = maxLife;
		
		minWorkDuration = Std.int(Assets.FPS * 2);
		maxWorkDuration = Std.int(Assets.FPS * 4);
			
    }
	
	public function work(pWorkbench:Workbench):Void{
		this.currentWorkbench = pWorkbench;
		this.currentWorkbench.worker = this;

		cd.add("worked", MathUtils.irnd(minWorkDuration, maxWorkDuration), goIdle);	
	}
	
	public function goIdle():Void{
		if(this.currentWorkbench != null){
			this.currentWorkbench.worker = null;
			this.currentWorkbench = null;
		}
		var cells:Array<Cell> = level.getMarkers("floor");
		var cell:Cell = cells[MathUtils.irnd(0, cells.length)];
		this.state = "idle";
		this.goto(cell);
		this.start();
	}
	
	
	public function shocked() : Void {
		if (cd.has("shocked")) return;
		if(this.currentWorkbench != null){
			this.currentWorkbench.worker = null;
			this.currentWorkbench = null;
		}
		this.clearPath();
		this.paused = true;
		cd.add("shocked", SHOCKED_DURATION, function(){
			trace("ok go to work");
			this.paused = false;
			findWorkbench();
		});
	}
	

	public function findWorkbench():Void{
		var validWorkbenchs:Array<Workbench> = new Array<Workbench>();
		for (w in workbenchs){
			if (w.worker == null){
				validWorkbenchs.push(w);
			}
		}
		
		var minDist:Int = -1;
		var nearestW:Workbench =null;
		for (w in validWorkbenchs){
			if (minDist < 0){
				nearestW = w;
				minDist = MathUtils.intSquareDistance(this.cx, this.cy, w.cell.cx, w.cell.cy);
			}else{
				var dist:Int = MathUtils.intSquareDistance(this.cx, this.cy, w.cell.cx, w.cell.cy);
				if (dist < minDist){
					nearestW = w;
					minDist = dist;
				}
			}
		}
	trace(nearestW);
		if (nearestW != null){
			trace(nearestW.cell);
			this.state = "goWork";
			this.currentWorkbench = nearestW;
			this.currentWorkbench.worker = this;
			this.goto(nearestW.cell);
			this.start();
		}
	}
	
	inline override public function execute(pDelta : Float = 1.0) : Void
    {
		super.execute(pDelta);
    }
	
	public inline function goto(end:Cell):Void{
		var start:Cell = level.getCell(this.cx, this.cy);
		var result:ObjectMap<Dynamic,Dynamic> = AStar.search(start, end, getNeighborsCells, DungeonGeneratorUtils.getCellsHeuristic, DungeonGeneratorUtils.getCellsHeuristic);
		var current : Cell = start;
		var next : Cell;
		this.stop();
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
		trace("pathCompleted", this.state);
		switch(this.state){
			case "goWork":
				work(this.currentWorkbench);
		}
		
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