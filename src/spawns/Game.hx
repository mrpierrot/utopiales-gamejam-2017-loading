package spawns;

import jammer.controls.Mouse;
import jammer.engines.pathfinding.BreadthFirstSearch;
import jammer.engines.spawn.Spawn;
import jammer.engines.spawn.SpawnManager;
import spawns.Assets;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextField;
import jammer.AbstractGame;
import jammer.Context;
import jammer.controls.Key;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.camera.CameraSmoothMovement;
import jammer.engines.display.MozaicFactory;
import jammer.engines.display.types.JamBitmap;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.engines.level.parsers.LevelBitmapParser;
import jammer.engines.lights.DarknessLayer;
import jammer.engines.lights.FogOfWar;
import jammer.engines.lights.LightPostRendering;
import jammer.engines.lights.LightsContainer;
import jammer.engines.lights.LightSource;
import jammer.utils.FilterUtils;
import jammer.utils.LevelUtils;
import jammer.utils.MathUtils;
import jammer.utils.TilePatternUtils;
import spawns.Mob;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Game extends AbstractGame
{
    public var fow : FogOfWar;
    private var hero : Hero;
    private var lightsContainer : LightsContainer;
    private var darknessLayer : DarknessLayer;
    private var heroLight : LightSource;
    private var _destPoint : Point = new Point();
    private var level : Level;

	private var mobs:Array<Mob>;
	var spawnManager:SpawnManager;
	var spawns:Array<Spawn>;
    
    public function new(pContainer : Sprite)
    {
        //super(pContainer,4,0xff60597B);
        super(pContainer, 4 / (Assets.TILE_SIZE / 16), 0xFFfdfdfd);
    }
    
    override public function initialize() : Void
    {
        AssetsManager.instance.importFromClassMap(Assets);
		
		AssetsManager.instance.getAsset("level");
   
        hero = new Hero();
        heroLight = new LightSource(0, 0, 3, 0xE3F086, 0.5);
        renderingEngine.add(hero.skin, Context.LAYER_CONTENT);
       
        
        renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
        
        //renderingEngine.buffer.camera.movementStrategy = new CameraSmoothMovement();
        
        
        
        level = _initLevel();
    }
    
    
    private function _initLevel() : Level
    {
        var level:Level = _createLevel();

        renderingEngine.buffer.camera.movementStrategy = new CameraSmoothMovement();
        renderingEngine.buffer.camera.world = level.getBounds();
        renderingEngine.buffer.camera.lockOn(hero.skin);
        renderingEngine.buffer.camera.reset();
        return level;
    }
    
    private function _createLevel() : Level
    {
		
		var floor:String = "default";
		
        var level : Level = LevelBitmapParser.parse(AssetsManager.instance.getAsset("level").data, 32, 26, [
			0xe9ff31 => ["floor",floor,"light"],
			0x000000 => ["floor",floor],
			0xffffff => ["wall"],
			0xac956e => ["floor",floor,"start"],
		
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
			}, {
				selector : "start",
				render : function(pCell : Cell) : Void
				{
					hero.level = level;
					hero.setCellPosition(pCell.cx, pCell.cy);
				}
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
		
		
		/*var spawnManager:SpawnManager = new SpawnManager(level,Vector.<Class>([Hero]));
			
			spawns = Vector.<Spawn>([spawnManager.createRandomSpawn(Vector.<Class>([Mob]), 6, 3,500,60)]);*/
		
		spawnManager = new SpawnManager(level, [Mob]);
		spawns = [spawnManager.createRandomSpawn([Mob], 6, 3,500,60)];
			
		mobs = [];
			
		var mob:Mob = new Mob();
		renderingEngine.add(mob.skin, Context.LAYER_CONTENT);
		mob.level = level;
		mob.setCellPosition(3, 4);
		mob.start();
		mobs.push(mob);
		
		mob = new Mob();
		renderingEngine.add(mob.skin, Context.LAYER_CONTENT);
		mob.level = level;
		mob.setCellPosition(5, 3);
		mob.start();
		mobs.push(mob);
             
        lightsContainer = new LightsContainer(
                level, 
                {
                    darknessColor : 0,
                    lightDownWall : true,
                    downWallCeilSize : 2 * Assets.TILE_SIZE / 16,
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
        
        fow = new FogOfWar(level, 0xFF000000, true, 0);
        fow.postFilter = new GlowFilter(0xFF000000, 1, 2, 2, 20, 3, false);
        fow.color = new ColorTransform(1, 1, 1, 1);
        
        renderingEngine.clearLayer(Context.LAYER_BACKGROUND);
        renderingEngine.clearLayer(Context.LAYER_FOREGROUND);
        
        level.getLayerByName("wood-floor").applyFilter(new BevelFilter(1, 45, 0x614634, 1, 0x614634, 1, 1, 1, 10, 3));
        
        
      /*  var desaturate:BitmapFilter = FilterUtils.desaturate(1, 1);
        level.getLayerByName("floor").applyFilter(desaturate);
        level.getLayerByName("wood-floor").applyFilter(desaturate);
        level.getLayerByName("walls").applyFilter(desaturate);
        level.getLayerByName("wall-over").applyFilter(desaturate);
        level.getLayerByName("over").applyFilter(desaturate);
        lightsContainer.applyFilter(desaturate);
        hero.skin.frameData.asset.applyFilter(hero.skin.frameData.asset,hero.skin.frameData.asset.rect,new Point(),desaturate);*/
        
        renderingEngine.add(level.getLayerByName("floor"), Context.LAYER_BACKGROUND);
        renderingEngine.add(level.getLayerByName("wood-floor"), Context.LAYER_BACKGROUND);
        renderingEngine.add(level.getLayerByName("walls"), Context.LAYER_BACKGROUND);
        renderingEngine.add(lightsContainer, Context.LAYER_BACKGROUND);
        //renderingEngine.add(level.getLayerByName("lights"), Context.LAYER_BACKGROUND);
        renderingEngine.add(level.getLayerByName("wall-over"), Context.LAYER_FOREGROUND);
        renderingEngine.add(darknessLayer, Context.LAYER_FOREGROUND);
        renderingEngine.add(level.getLayerByName("over"), Context.LAYER_FOREGROUND);
        //renderingEngine.add(level.getLayerByName("grid"), Context.LAYER_FOREGROUND);
        fow.y -= 2;
        renderingEngine.add(fow, Context.LAYER_FOREGROUND);
		
		 renderingEngine.add(hero.halo, Context.LAYER_FOREGROUND);
		
		return level;
    }
    
    
    override public function update(pDelta : Float = 1.0) : Void
    {
        hero.update(pDelta);
        heroLight.x = hero.x;
        heroLight.y = hero.y;
        //heroLight.intensity = 0.8 + 0.05 * MathUtils.fabs(Math.sin(getTimer() / 1000));
        heroLight.intensity = 0.7 + 0.3 * MathUtils.fabs(Math.sin(Math.round(haxe.Timer.stamp() * 1000) / 1000));
        
		Fx.cubeHurted(0, 0, hero.skin, null);
		
		BreadthFirstSearch.update(level, hero.cx, hero.cy);
		
		for (mob in mobs) {
			mob.update(pDelta);
			for (m in mobs) {
				
				mob.collide(m);
			}
		}
		

		for (spawn in spawns) {
		
			for (mob in spawn.wave) {
				renderingEngine.add(mob.skin, Context.LAYER_CONTENT);
				mobs.push(cast(mob,Mob));
				cast(mob,Mob).start();
			}
		}
		
        fow.reveal(hero.cx, hero.cy, 8);
        renderingEngine.ysort(Context.LAYER_CONTENT);

        
        //lightsContainer.applyCamera(renderingEngine.buffer.camera);
        //lightsContainer.render();
        //darknessLayer.update(lightsContainer);
        
        if (Key.isToggled(Key.A))
        {
            scale = 1;
            renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
        }
        if (Key.isToggled(Key.Z))
        {
            scale = 2;
            renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
        }
        if (Key.isToggled(Key.E))
        {
            scale = 4;
            renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
        }
        if (Key.isToggled(Key.R))
        {
            scale = 8;
            renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
        }
		
		if (Mouse.isClicked()) {
			trace(Mouse.localX, Mouse.localY);
		}
        
        super.update(pDelta);
    }
}

