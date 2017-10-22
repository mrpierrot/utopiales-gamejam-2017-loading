package jammer;

import jammer.assets.DefaultFontsLib;
import jammer.controls.Key;
import jammer.controls.Mouse;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.particles.ParticlesContainer;
import jammer.engines.display.RenderingEngine;
import jammer.engines.display.text.Message;
import jammer.engines.display.text.MessageFactory;
import jammer.process.Cooldown;
import jammer.process.Process;
import flash.display.Sprite;
import flash.display.Stage;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class AbstractGame
{
    public var scale(get, set) : Float;

    
    
    
    public var renderingEngine : RenderingEngine;
    public var stage : Stage;
    private var _scale : Float;
    public var fps : Int;
    public var messages : MessageFactory;
    public var particles : ParticlesContainer;
    public var updateProcess : Process;
    public var renderProcess : Process;
    public var cd : Cooldown;
    
    public function new(pContainer : Sprite, pScale : Float = 1, pBackgroundColor : Int = 0xFF000000)
    {
        _scale = pScale;
        stage = pContainer.stage;
        Process.initialise(stage);
        Key.init(stage);
        Mouse.init(stage);
        Context.stage = stage;
        Context.fps = Std.int(stage.frameRate);
        Context.game = this;
        Context.scale = _scale;
        Context.width = Std.int(stage.stageWidth / _scale);
        Context.height = Std.int(stage.stageHeight / _scale);
        particles = new ParticlesContainer();
        
        
        
        renderingEngine = new RenderingEngine(stage.stageWidth, stage.stageHeight, Context.fps, scale, pBackgroundColor);
        renderingEngine.createLayer(Context.LAYER_BACKGROUND);
        renderingEngine.createLayer(Context.LAYER_CONTENT);
        renderingEngine.createLayer(Context.LAYER_FOREGROUND);
        renderingEngine.createLayer(Context.LAYER_PARTICLES);
        renderingEngine.createLayer(Context.LAYER_MESSAGES);
        renderingEngine.createLayer(Context.LAYER_UI);
        
        renderingEngine.add(particles, Context.LAYER_PARTICLES);
        
        pContainer.addChild(renderingEngine.buffer);
        AssetsManager.instance.defaultFont = DefaultFontsLib.DEFAULT;
        AssetsManager.instance.importFontsLib(DefaultFontsLib.FONTS);
        messages = new MessageFactory(this.renderingEngine, Context.LAYER_MESSAGES);
        
        cd = new Cooldown(100);
        
        updateProcess = new Process(0, "Update");
        updateProcess.onRun = run;
        
        renderProcess = new Process(-1000, "Render");
        renderProcess.onRun = render;
        
        
        initialize();
        trace(Process.ALL);
    }
    
    public function initialize() : Void
    {
    }
    
    @:final public function run(pDelta : Float = 1.0) : Void
    {
        Key.update();
        Mouse.localX = renderingEngine.buffer.localMouseX;
        Mouse.localY = renderingEngine.buffer.localMouseY;
        Mouse.update();
        update(pDelta);
    }
    
    public function update(pDelta : Float = 1.0) : Void
    {
    }
    
    
    
    public function render(pDelta : Float = 1.0) : Void
    {
        renderingEngine.buffer.update();
    }
    
    private function get_scale() : Float
    {
        return _scale;
    }
    
    private function set_scale(value : Float) : Float
    {
        _scale = value;
        Context.scale = _scale;
        renderingEngine.buffer.scale = _scale;
        return value;
    }
}

