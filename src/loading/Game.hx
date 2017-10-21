package loading;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.Rectangle;
import jammer.AbstractGame;
import jammer.Context;
import jammer.controls.Key;
import jammer.engines.display.MozaicFactory;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.engines.level.parsers.LevelBitmapParser;
import jammer.engines.lights.DarknessLayer;
import jammer.engines.lights.LightPostRendering;
import jammer.engines.lights.LightSource;
import jammer.engines.lights.LightsContainer;
import jammer.utils.LevelUtils;
import jammer.utils.MathUtils;
import jammer.utils.TilePatternUtils;
import loading.Assets;

/**
 * ...
 * @author Pierre Chabiland
 */
class Game extends AbstractGame
{

	private var level : Level;
	var lightsContainer:LightsContainer;
	var darknessLayer:DarknessLayer;
	var world:Rectangle;
	var workers:Array<Hamster>;
	var workbenchs:Array<Workbench>;
	public static var LAYER_WORKBENCH : String = "workbenchs";
	 
	public function new(pContainer : Sprite) 
	{
		super(pContainer, 4 / (Assets.TILE_WIDTH / 16), 0xFFfdfdfd);
		
	}
	
	override public function initialize() : Void{
		AssetsManager.instance.importFromClassMap(Assets);
		
		renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
		renderingEngine.createLayer(LAYER_WORKBENCH, null, Context.LAYER_FOREGROUND);
		workers = new Array<Hamster>();
		workbenchs = new Array<Workbench>();
		level = _createLevel();
	}
	
	
	private function _createLevel() : Level
    {
		
		var floor:String = "floor";
		
        var newLevel : Level = LevelBitmapParser.parse(AssetsManager.instance.getAsset("level").data, Assets.TILE_WIDTH, Assets.TILE_HEIGHT, [
			0xe9ff31 => [floor,"light"],
			0x6600ff => [floor,"workbench"],
			0x000000 => [floor],
			0xffffff => ["wall"]
		]);
		
		var lights:Array<LightSource> = []; 	
        
        var layers : Array<Dynamic> = [
			{
				name : "floor",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}, 
			{
				name : "walls",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}, 
			{
				name : "wall-over",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}, 
			{
				name : "over",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}, 
			{
				name : "lights",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}, 
			{
				name : "grid",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}
		];
		
		var markers : Dynamic = [
			{
				selector : "floor",
				layers : [
					"floor" => {
						fill : "slabs2",
						pattern : TilePatternUtils.createWeightRandomPattern([10, 1, 10])
					}
				]
			}, {
				selector : "wall",
				opaque : true,
				collide: true,
				layers : [
					"walls" => {
						fill : "wall-fill",
						down : "wall-down"
					},
					"wall-over" => {
						fill : "wall-fill",
						down : "wall-down-over"
					}
				]
			}, {
				selector : "light",
				render : function(pCell : Cell) : Void
				{
					
					lights.push(new LightSource(Std.int((pCell.cx + 0.5) * newLevel.tileWidth), Std.int((pCell.cy + 0.5) * newLevel.tileHeight), MathUtils.irnd(3, 5), Std.int( Math.random() * 0xFFFFFF), 1));
				},
				layers : [
					"lights" => {fill:"light"}
				]
			},{
				selector : "workbench",
				render : function(pCell : Cell) : Void
				{
					trace("worker");
					createWorker(pCell);
					createWorkbench(pCell);
				},
				layers : [
					"lights" => {fill:"light"}
				]
			},{
				selector : "",
				opaque : true,
				defaultMarker : true,
				layers : [
					"over" => {
						fill : {fill:"empty"},
						down : {fill:"empty"}
					}
				]
			}
		];
        
        LevelUtils.renderLevel(newLevel, layers, markers);
		
		       
        lightsContainer = new LightsContainer(
                newLevel, 
                {
                    darknessColor : 0,
                    lightDownWall : true,
                    downWallCeilSize : 2 * Assets.TILE_WIDTH / 16,
                    floorDistance : true,
                    fatLineChecking : true,
					staticLights:  lights,
					//dynamicLights:  [heroLight],
                    split : 3
                });
        lightsContainer.blendMode = BlendMode.HARDLIGHT;
        lightsContainer.color.alphaMultiplier = 0.5;
        
        lightsContainer.postRendering = LightPostRendering.createPillowShading(newLevel.tileWidth, newLevel.tileHeight, 6, 0.5);
        
        lightsContainer.render();
        
        darknessLayer = lightsContainer.createDarknessLayer(20, 255, 20, BlendMode.MULTIPLY);
        darknessLayer.update(lightsContainer);
         
        newLevel.getLayerByName("wall-over").y = -8;
		
		renderingEngine.clearLayer(Context.LAYER_BACKGROUND);
        renderingEngine.clearLayer(Context.LAYER_FOREGROUND);
       
		
		renderingEngine.add(newLevel.getLayerByName("floor"), Context.LAYER_BACKGROUND);
        renderingEngine.add(newLevel.getLayerByName("walls"), Context.LAYER_BACKGROUND);
       // renderingEngine.add(lightsContainer, Context.LAYER_BACKGROUND);
        //renderingEngine.add(level.getLayerByName("wall-over"), Context.LAYER_FOREGROUND);
        renderingEngine.add(darknessLayer, Context.LAYER_FOREGROUND);
        renderingEngine.add(newLevel.getLayerByName("over"), Context.LAYER_FOREGROUND);
		
		world = new Rectangle(0, 0,
			-(newLevel.cols * newLevel.tileWidth - renderingEngine.buffer.width * 0.5),
			-(newLevel.rows * newLevel.tileHeight - renderingEngine.buffer.height * 0.5)
		);
		
		renderingEngine.buffer.camera.centerX = 0;
		renderingEngine.buffer.camera.centerY = 0;
		//renderingEngine.buffer.camera.world  = world;
		
		return newLevel;
	}
	
	public function createWorker(pCell:Cell):Hamster {
		var worker:Hamster = new Hamster();
		workers.push(worker);
		renderingEngine.add(worker.skin, Context.LAYER_CONTENT);
		worker.level = pCell.level;
		worker.setCellPosition(pCell.cx, pCell.cy);
		return worker;
	}
	
	public function createWorkbench(pCell:Cell):Workbench {
		var workbench:Workbench = new Workbench();
		workbenchs.push(workbench);
		renderingEngine.add(workbench.skin, LAYER_WORKBENCH);
		workbench.setCellPosition(pCell);
		return workbench;
	}
	
	override public function update(pDelta : Float = 1.0) : Void
    {
		
		for (worker in workers) {
			worker.update(pDelta);
			worker.action(workbenchs);
				
		}
		
		renderingEngine.ysort(Context.LAYER_CONTENT);
		
		if (Key.isDown(Key.Z))
        {
            renderingEngine.buffer.camera.centerY += 10;
          
        }
        if (Key.isDown(Key.Q))
        {
           renderingEngine.buffer.camera.centerX += 10;
		  
        }
        if (Key.isDown(Key.S))
        {
           renderingEngine.buffer.camera.centerY -= 10;
        }
        if (Key.isDown(Key.D))
        {
           renderingEngine.buffer.camera.centerX -= 10;
        }

		if (renderingEngine.buffer.camera.centerX > world.x) renderingEngine.buffer.camera.centerX = Std.int(world.x);
		if (renderingEngine.buffer.camera.centerX < world.width)  renderingEngine.buffer.camera.centerX = Std.int(world.width);
		if (renderingEngine.buffer.camera.centerY > world.y)  renderingEngine.buffer.camera.centerY = Std.int(world.y);
		if (renderingEngine.buffer.camera.centerY < world.height)  renderingEngine.buffer.camera.centerY = Std.int(world.height);
		renderingEngine.buffer.camera.update();
	}
}