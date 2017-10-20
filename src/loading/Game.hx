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
	 
	public function new(pContainer : Sprite) 
	{
		 super(pContainer, 4 / (Assets.TILE_WIDTH / 16), 0xFFfdfdfd);
	}
	
	override public function initialize() : Void{
		AssetsManager.instance.importFromClassMap(Assets);
		
		AssetsManager.instance.getAsset("level");
		
		renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
		
		level = _createLevel();
	}
	
	
	private function _createLevel() : Level
    {
		
		var floor:String = "default";
		
        var level : Level = LevelBitmapParser.parse(AssetsManager.instance.getAsset("level").data, Assets.TILE_WIDTH, Assets.TILE_HEIGHT, [
			0xe9ff31 => ["floor",floor,"light"],
			0x000000 => ["floor",floor],
			0xffffff => ["wall"],
			0xac956e => ["floor",floor,"start"]
		]);
		
		var lights:Array<LightSource> = []; 	
        
        var layers : Array<Dynamic> = [
			{
				name : "floor",
				assets : AssetsManager.instance.getTileSetAsset("floors")
			}, 
			{
				name : "wood-floor",
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
				selector : "floor default",
				layers : [
					"floor" => {
						fill : "slabs",
						pattern : TilePatternUtils.createWeightRandomPattern([10, 2, 10, 10, 10, 10])
					}
				]
			}, {
				selector : "floor clay",
				layers : [
					"floor" => {
						fill : "clay",
						pattern : TilePatternUtils.createWeightRandomPattern([5, 5, 5, 5])
					}
				]
			}, {
				selector : "floor clay-2",
				layers : [
					"floor" => {
						fill : "clay-2",
						pattern : TilePatternUtils.createWeightRandomPattern([10, 0.5, 2, 2, 2, 2, 2, 2, 2, 2])
					}
				]
			}, {
				selector : "floor wood",
				layers : [
					"wood-floor" => {fill:"wood"}
				]
			}, {
				selector : "floor",
				layers : [
					"grid" => {
						fill : "grid",
						pattern : TilePatternUtils.alternatePattern
					}
				]
			}, {
				selector : "wall !exit",
				opaque : true,
				collide: true,
				layers : [
					"walls" => {
						fill : "wall-fill",
						down : "block-wall-down"
					},
					"wall-over" => {
						fill : "wall-down-over",
						down : "wall-down-over"
					}
				]
			}, {
				selector : "wall exit",
				opaque : false,
				layers : [
					"walls" => {fill:"door-down"}
				]
			}, {
				selector : "light",
				render : function(pCell : Cell) : Void
				{
					
					lights.push(new LightSource(Std.int((pCell.cx + 0.5) * level.tileWidth), Std.int((pCell.cy + 0.5) * level.tileHeight), MathUtils.irnd(3, 5), Std.int( Math.random() * 0xFFFFFF), 1));
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
						fill : {fill:"blackFill"},
						down : {fill:"empty"}
					}
				]
			}
		];
        
        LevelUtils.renderLevel(level, layers, markers);
		
		       
        lightsContainer = new LightsContainer(
                level, 
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
        
        lightsContainer.postRendering = LightPostRendering.createPillowShading(level.tileWidth, level.tileHeight, 6, 0.5);
        
        lightsContainer.render();
        
        darknessLayer = lightsContainer.createDarknessLayer(20, 255, 20, BlendMode.MULTIPLY);
        darknessLayer.update(lightsContainer);
         
        level.getLayerByName("wall-over").y = -8;
		
		renderingEngine.clearLayer(Context.LAYER_BACKGROUND);
        renderingEngine.clearLayer(Context.LAYER_FOREGROUND);
       
		
		renderingEngine.add(level.getLayerByName("floor"), Context.LAYER_BACKGROUND);
        renderingEngine.add(level.getLayerByName("wood-floor"), Context.LAYER_BACKGROUND);
        renderingEngine.add(level.getLayerByName("walls"), Context.LAYER_BACKGROUND);
        renderingEngine.add(lightsContainer, Context.LAYER_BACKGROUND);
        renderingEngine.add(level.getLayerByName("wall-over"), Context.LAYER_FOREGROUND);
        renderingEngine.add(darknessLayer, Context.LAYER_FOREGROUND);
        renderingEngine.add(level.getLayerByName("over"), Context.LAYER_FOREGROUND);
		
		world = new Rectangle(0, 0,
			-(level.cols * level.tileWidth - renderingEngine.buffer.width * 0.5),
			-(level.rows * level.tileHeight - renderingEngine.buffer.height * 0.5)
		);
		
		renderingEngine.buffer.camera.centerX = 0;
		renderingEngine.buffer.camera.centerY = 0;
		//renderingEngine.buffer.camera.world  = world;
		
		return level;
	}
	
	override public function update(pDelta : Float = 1.0) : Void
    {
		
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
		trace(renderingEngine.buffer.camera.centerX, renderingEngine.buffer.width, world);
		trace(level.cols, level.tileWidth);
		renderingEngine.buffer.camera.update();
	}
}