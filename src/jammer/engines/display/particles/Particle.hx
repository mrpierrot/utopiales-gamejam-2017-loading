package jammer.engines.display.particles;

import haxe.Constraints.Function;
import jammer.collections.Node;
import jammer.engines.display.types.JamDisplayObject;
import jammer.utils.MathUtils;
import flash.display.BlendMode;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.VideoEvent;
import flash.geom.Matrix;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Particle extends Sprite
{
    
    public var env : ParticlesEnvironnement;
    public var xx : Float;
    public var yy : Float;
    public var dx : Float;
    public var dy : Float;
    public var deltaAlpha : Float;
    public var deltaScale : Float;
    public var deltaScaleX : Float;
    public var deltaScaleY : Float;
    public var deltaRotation : Float;
    public var gravityX : Float;
    public var gravityY : Float;
    public var frictX : Float;
    public var frictY : Float;
    public var groundY : Float;
    public var bounce : Float;
    public var node : Node;
    public var windAffect : Bool;
    public var delay : Int;
    public var life : Int;
    public var pixelSnapping : Bool;
    public var fadeOutSpeed : Float;
    public var onUpdate : Function;
    public var onKill : Function;
    public var onStart : Function;
    public var onBounce : Function;
    public var target : JamDisplayObject;
    private static var _identity : Matrix = new Matrix();
    
    public function new()
    {
        super();
        reset(0, 0);
    }
    
    public function reset(pX : Int, pY : Int, env : ParticlesEnvironnement = null) : Void
    {
        if (env == null)
        {
            env = ParticlesEnvironnement.DEFAULT;
        }
        xx = pX;
        yy = pY;
        dx = dy = deltaAlpha = deltaScaleX = deltaScaleY = deltaScale = deltaRotation = 0;
        gravityX = 0;
        gravityY = env.gravityY + Std.int(Math.random() * env.gravityY * 10) / 10;
        windAffect = false;
        delay = 0;
        bounce = 0.85;
        frictX = 0.95 + Math.random() * 40 / 1000;
        frictY = 0.97;
        life = Std.int(32 + Math.random() * 32);
        fadeOutSpeed = 0.1;
        alpha = 1;
        groundY = Math.NaN;
        pixelSnapping = false;
        onUpdate = onBounce = onStart = onKill = null;
        this.graphics.clear();
        this.removeChildren();
        blendMode = BlendMode.NORMAL;
        target = null;
        filters = [];
        this.transform.matrix = _identity;
    }
    
    
    @:final public function drawBox(pWidth : Float, pHeight : Float, pColor : Int, pAlpha : Float = 1.0, pFill : Bool = true, pLineThickness : Float = 1.0) : Void
    {
        graphics.clear();
        if (pFill)
        {
            graphics.beginFill(pColor, pAlpha);
        }
        else
        {
            graphics.lineStyle(pLineThickness, pColor, pAlpha);
        }
        graphics.drawRect(Std.int(pWidth * 0.5), Std.int(pHeight * 0.5), pWidth, pHeight);
        graphics.endFill();
    }
    
    
    @:final public function drawCircle(pRadius : Float, pColor : Int, pAlpha : Float = 1.0, pFill : Bool = true, pLineThickness : Float = 1.0) : Void
    {
        graphics.clear();
        if (pFill)
        {
            graphics.beginFill(pColor, pAlpha);
        }
        else
        {
            graphics.lineStyle(pLineThickness, pColor, pAlpha, true, LineScaleMode.NONE);
        }
        graphics.drawCircle(0, 0, pRadius);
        graphics.endFill();
    }
    
    public function destroy() : Void
    {
        if (parent != null)
        {
            parent.removeChild(this);
        }
    }
}

