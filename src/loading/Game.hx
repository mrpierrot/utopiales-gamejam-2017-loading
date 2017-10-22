package loading;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.display3D.textures.VideoTexture;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;
import jammer.AbstractGame;
import jammer.Context;
import jammer.controls.Key;
import jammer.controls.Mouse;
import jammer.engines.display.MozaicFactory;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.text.JamFlashText;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.display.types.JamFlashSprite;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.engines.level.parsers.LevelBitmapParser;
import jammer.engines.lights.DarknessLayer;
import jammer.engines.lights.LightPostRendering;
import jammer.engines.lights.LightSource;
import jammer.engines.lights.LightsContainer;
import jammer.engines.sounds.SoundManager;
import jammer.process.Sequence;
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
	var currentLoading :Int;
	var totalLoading :Int;
	var gameover: Bool;
	var gauge:Gauge;
	var frameTime :Int; // en frame
	var timeText : String;
	var timeTextUI: TextField;
	var totalTime :Int = 60; // en seconde
	var cursor : JamAnimation;
	var sequence:Sequence;
	var playing:Bool;
	var jamSPTime:JamFlashSprite;
	
	
	public static var LAYER_HIGHLIGHT : String = "hightlight";
	public static var LAYER_SHOCK : String = "shock";
	 
	public function new(pContainer : Sprite) 
	{
		super(pContainer, 4 / (Assets.TILE_WIDTH / 16), 0xFFfdfdfd);
		
	}
	
	override public function initialize() : Void{
		AssetsManager.instance.importFromClassMap(Assets);
		SoundManager.instance.importFromMap(Assets.sounds);
		Context.game.messages.addTheme("hbox",new HBoxMessageTheme());
		
		renderingEngine.buffer.setTexture(MozaicFactory.makeScanline(Std.int(scale)), 0.1, BlendMode.MULTIPLY);
		renderingEngine.createLayer(LAYER_HIGHLIGHT, null, Context.LAYER_MESSAGES);
		renderingEngine.createLayer(LAYER_SHOCK, null, Context.LAYER_MESSAGES);
		workers = new Array<Hamster>();
		workbenchs = new Array<Workbench>();
		gauge = new Gauge();
		gauge.noCamera = true;
		gauge.progress(100, 100);
		gauge.x = Std.int((this.renderingEngine.buffer.camera.width - gauge.width) * 0.5);
		gauge.y = Std.int((this.renderingEngine.buffer.camera.height - gauge.height) - 5);
		renderingEngine.add(gauge, Context.LAYER_UI);
		
		timeTextUI = AssetsManager.instance.createFlashText(formatTime(Assets.FPS * totalTime), 16);

		jamSPTime = new JamFlashSprite();
		jamSPTime.sprite.addChild(timeTextUI);
		jamSPTime.noCamera = true;
		jamSPTime.x = Std.int((this.renderingEngine.buffer.camera.width - timeTextUI.textWidth) * 0.5);
		jamSPTime.y = 5;
		jamSPTime.sprite.filters = [
            new GlowFilter(0x0, 1, 2, 2, 4, 1, false)
        ];
		renderingEngine.add(jamSPTime, Context.LAYER_UI);
		
		cursor = AssetsManager.instance.createAnimation("cursor");
		renderingEngine.add(cursor, Context.LAYER_CURSOR);
		
		SoundManager.instance.playMusic("music");
		
		this.start();
	}
	
	public function start() :Void {
		level = _createLevel();
	}
	
	
	private function _createLevel() : Level
    {
		currentLoading = 0;
		gameover = false;
		playing = false;
		gauge.visible = false;
		jamSPTime.visible = false;
		frameTime = Assets.FPS * totalTime;
		timeText = formatTime(frameTime);
		
		workers.splice(0, workers.length);
		workbenchs.splice(0, workbenchs.length);
		renderingEngine.clearLayer(Context.LAYER_BACKGROUND);
        renderingEngine.clearLayer(Context.LAYER_FOREGROUND);
        renderingEngine.clearLayer(Context.LAYER_CONTENT);
        renderingEngine.clearLayer(Context.LAYER_MESSAGES);
        renderingEngine.clearLayer(LAYER_SHOCK);
        renderingEngine.clearLayer(LAYER_HIGHLIGHT);
		
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
						fill : "slabs",
						pattern : TilePatternUtils.createWeightRandomPattern([10, 1, 10])
					}
				],
				render : function(pCell : Cell) : Void
				{
					pCell.addMarker("floor");
				}
			}, {
				selector : "wall",
				opaque : true,
				collide: true,
				layers : [
					"walls" => {
						fill : "wall-fill",
						down : "wall-down",
						pattern : TilePatternUtils.createWeightRandomPattern([10, 10, 1])
					},
					"wall-over" => {
						fill : "wall-fill",
						down : "wall-down-over",
						pattern : TilePatternUtils.createWeightRandomPattern([10, 10, 1])
					}
				]
			}, {
				selector : "light",
				render : function(pCell : Cell) : Void
				{
					
					//lights.push(new LightSource(Std.int((pCell.cx + 0.5) * newLevel.tileWidth), Std.int((pCell.cy + 0.5) * newLevel.tileHeight), MathUtils.irnd(3, 5), Std.int( Math.random() * 0xFFFFFF), 1));
					lights.push(new LightSource(Std.int((pCell.cx + 0.5) * newLevel.tileWidth), Std.int((pCell.cy + 0.5) * newLevel.tileHeight), MathUtils.irnd(3, 5), 0x3F9E7A, 1));
				},
				layers : [
					"lights" => {fill:"light"}
				]
			},{
				selector : "workbench",
				render : function(pCell : Cell) : Void
				{
					var workbench:Workbench =  createWorkbench(pCell);
					var worker = createWorker(pCell);
					worker.work(workbench);
				},
				layers : [
					"lights" => {fill:"light"}
				]
			},{
				selector : "floor !workbench",
				render : function(pCell : Cell) : Void
				{
					pCell.addMarker("idle-available");
				}
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
		
		totalLoading = workers.length * Assets.FPS * 30;
		       
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
		
		
		trace(renderingEngine.children);
       
		
		renderingEngine.add(newLevel.getLayerByName("floor"), Context.LAYER_BACKGROUND);
        renderingEngine.add(newLevel.getLayerByName("walls"), Context.LAYER_BACKGROUND);
        
        renderingEngine.add(newLevel.getLayerByName("wall-over"), Context.LAYER_FOREGROUND);
		renderingEngine.add(lightsContainer, Context.LAYER_BACKGROUND);
        renderingEngine.add(darknessLayer, Context.LAYER_FOREGROUND);
        renderingEngine.add(newLevel.getLayerByName("over"), Context.LAYER_FOREGROUND);
		
		world = new Rectangle(0, 0,
			-(newLevel.cols * newLevel.tileWidth - renderingEngine.buffer.width * 0.5),
			-(newLevel.rows * newLevel.tileHeight - renderingEngine.buffer.height * 0.5)
		);
		
		renderingEngine.buffer.camera.centerX = 0;
		renderingEngine.buffer.camera.centerY = 0;
		
		//renderingEngine.buffer.camera.centerX = Std.int(world.width * 0.5);
		//renderingEngine.buffer.camera.centerY = Std.int(world.height * 0.5);
		
		sequence = Sequence.create([
			function(cb:Int->Void):Void{  
				messages.create("Hamster Damn", "center", "center", "simple"); cb(100); 
				messages.create("Appuyez sur [ESPACE] pour continuer", "center", "bottom", "hbox", -1, 
					function():Bool{ 
						if (Key.isToggled(Key.SPACE)){ return true; }
						else return false;
					}
				);
			},
			function(cb:Int->Void):Void { messages.create("Vos Hamsters font avancer un programme d’une importance capitale !", "center", "center", "simple"); cb(100); },
			function(cb:Int->Void):Void { messages.create("Mais ils procrastinent à mort. Maudits Hamsters !", "center", "center", "simple"); cb(100); },
			function(cb:Int->Void):Void { messages.create("Aidez-les à retrouver le chemin de la productivité.", "center", "center", "simple"); cb(100); },
			function(cb:Int->Void):Void { messages.create("Mettez les tir-au-flancs au “courant” de la deadline en cliquant dessus,", "center", "center", "simple"); cb(100); },
			function(cb:Int->Void):Void { messages.create("mais attention, les bosseurs n’ont pas besoin de “jus”", "center", "center", "simple"); cb(100); },
			function(cb:Int->Void):Void{ 
				messages.create("Utilises Z,Q,S,D pour deplacer la caméra,\ncliquez sur un hamster pour le taser.", "center", "center", "hbox", -1,
					function():Bool{ 
						if (Key.isToggled(Key.SPACE)){cb(0);return true; }
						else return false;
					}
				);
			},
			function(cb:Int->Void):Void{ 
				playing = true;
				
			}
		]);

		
		return newLevel;
	}
	
	public function createWorker(pCell:Cell):Hamster {
		var worker:Hamster = new Hamster(workbenchs);
		workers.push(worker);
		renderingEngine.add(worker.skin, Context.LAYER_CONTENT);
		renderingEngine.add(worker.halo, LAYER_HIGHLIGHT);
		renderingEngine.add(worker.shockedOver, LAYER_SHOCK);
		worker.level = pCell.level;
		worker.setCellPosition(pCell.cx, pCell.cy);
		return worker;
	}
	
	public function createWorkbench(pCell:Cell):Workbench {
		var workbench:Workbench = new Workbench();
		workbench.cell = pCell;
		workbenchs.push(workbench);
		renderingEngine.add(workbench.skin, Context.LAYER_CONTENT);
		workbench.setCellPosition(pCell);
		return workbench;
	}
	
	override public function update(pDelta : Float = 1.0) : Void
    {
		var mx:Int = Mouse.localX;
		var my:Int = Mouse.localY-6;
		cursor.x = mx;
		cursor.y = my;
		cursor.state = "pointer";
		var firstOver : Bool = false;
		if (!gameover && playing){
			gauge.visible = true;
			jamSPTime.visible = true;
			frameTime--;
			timeText = formatTime(frameTime);
			timeTextUI.text = timeText;
			for (worker in workers) {
				
				worker.halo.visible = false;
				if (!firstOver && (mx >= worker.x - worker.radius )
				&& (mx <= worker.x + worker.radius ) 
				&& (my >= worker.y - worker.radius ) 
				&& (my <= worker.y + worker.radius ) 
				){
					firstOver = true;
					worker.halo.visible = true;
					cursor.state = "shock1";
					
				}
				worker.update(pDelta);
				if (worker.state == "work") {
					currentLoading ++;
				}
					
			}
			gauge.progress(currentLoading, totalLoading);
			
		
			if (currentLoading >= totalLoading ){
				currentLoading = totalLoading;
				gameover = true;
				playing = false;
				trace("gameover");
				for (worker in workers) {
					worker.end();
					
				}
				
				messages.create("Vous avez fait preuve de zèle, c'est bien.\nVous avez gagnez.\nMais méfiez-vous tout de même des hamsters syndicalistes.", "center", "center", "hbox", -1);
				messages.create("Presse R\npour recommencer", "right", "bottom", "hbox", -1);
			}
			
			if (frameTime < 0 ){
				gameover = true;
				playing = false;
				trace("gameover");
				for (worker in workers) {
					worker.end();
					
				}
				
				messages.create("Vous faites un très mauvais manager.\nC'est perdu.", "center", "center", "hbox", -1);
				messages.create("Presse R\npour recommencer", "right", "bottom", "hbox", -1);
			}
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
		
		 if (Key.isDown(Key.R))
        {
           this.start();
        }
		
		if (!playing && Key.isToggled(Key.SPACE))
        {
			playing = true;
            sequence.destroyed = true;
			
		    renderingEngine.clearLayer(Context.LAYER_MESSAGES);
        }
		
		if (Mouse.isDown() && !gameover && playing){
			
			cursor.state = "shock2";
			for (worker in workers) {
				trace("hamster",worker.x, worker.y);
				if (mx < worker.x - worker.radius ) continue;
				if (mx > worker.x + worker.radius ) continue;
				if (my < worker.y - worker.radius ) continue;
				if (my > worker.y + worker.radius ) continue;
				worker.shocked();
				break;
				
			}
		}

		if (renderingEngine.buffer.camera.centerX > world.x) renderingEngine.buffer.camera.centerX = Std.int(world.x);
		if (renderingEngine.buffer.camera.centerX < world.width)  renderingEngine.buffer.camera.centerX = Std.int(world.width);
		if (renderingEngine.buffer.camera.centerY > world.y)  renderingEngine.buffer.camera.centerY = Std.int(world.y);
		if (renderingEngine.buffer.camera.centerY < world.height)  renderingEngine.buffer.camera.centerY = Std.int(world.height);
		renderingEngine.buffer.camera.update();
		
		
	}
	
	function formatTime(pFrameTime :Int) :String {
		var t:Int = Math.round(pFrameTime / Assets.FPS);
		var min:Int = Std.int(t / 60);
		var seconds:Int = t % 60;
		return (min < 10 ? "0" + min:min+"") + ":" + (seconds < 10 ? "0" + seconds:seconds+"");
	}
}