package jammer.engines.physics;

import jammer.engines.display.types.JamDisplayObject;
import jammer.engines.level.Level;
import jammer.utils.MathUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Entity
{
    
    
    public var skin : JamDisplayObject;
    public var x : Int;
    public var y : Int;
    public var cx : Int;
    public var cy : Int;
    public var xr : Float;
    public var yr : Float;
    public var dx : Float;
    public var dy : Float;
    public var radius : Float;
    public var level : Level;
    public var collisionEnabled : Bool;
    public var repulseEnabled : Bool;
    public var repulseForce : Float;
    public var dead : Bool;
    
    public function new(pSkin : JamDisplayObject)
    {
        skin = pSkin;
        reset();
    }
    
    
    public function update(pDelta : Float = 1.0) : Void
    {
    }
    
    
    
    public function setCellPosition(pX : Int, pY : Int) : Void
    {
        cx = pX;
        cy = pY;
        xr = 0.5;
        yr = 0.5;
        x = Std.int(level.tileWidth * (cx + xr));
        y = Std.int(level.tileHeight * (cy + yr));
    }
    
    public function setPosition(pX : Int, pY : Int) : Void
    {
        x = pX;
        y = pY;
        cx = Std.int(x / level.tileWidth);
        cy = Std.int(y / level.tileHeight);
        xr = (x - cx * level.tileWidth) / level.tileWidth;
        yr = (y - cy * level.tileHeight) / level.tileHeight;
    }
    
    public function reset() : Void
    {
        dead = false;
        collisionEnabled = false;
        repulseEnabled = false;
        radius = 8;
        repulseForce = 0.2;
    }
    
    public function destruct() : Void
    {
        dead = true;
    }
    
    @:meta(Inline())

    @:final public function collide(pEntity : Entity) : Bool
    {
        if (!collisionEnabled)
        {
            return false;
        }
        //if ( pEntity == this || MathUtils.iabs(cx - pEntity.cx) > 2 || MathUtils.iabs(cy - pEntity.cy) > 2) return false;
        if (pEntity == this || (((cx - pEntity.cx) < 0) ? -(cx - pEntity.cx) : (cx - pEntity.cx)) > 2 || (((cy - pEntity.cy) < 0) ? -(cy - pEntity.cy) : (cy - pEntity.cy)) > 2)
        {
            return false;
        }
        //var dist:Number = MathUtils.distance(pEntity.x, pEntity.y, x, y);
        var dist : Float = (pEntity.x - x) * (pEntity.x - x) + (pEntity.y - y) * (pEntity.y - y);
        if (dist <= (radius + pEntity.radius) * (radius + pEntity.radius))
        {
            if (repulseEnabled || pEntity.repulseEnabled)
            {
                dist = Math.sqrt(dist);
                var angle : Float = Math.atan2(pEntity.y - y, pEntity.x - x);
                var power : Float = (radius + pEntity.radius - dist) / (radius + pEntity.radius);
                if (repulseEnabled)
                {
                    dx -= Math.cos(angle) * power * pEntity.repulseForce;
                    dy -= Math.sin(angle) * power * pEntity.repulseForce;
                }
                if (pEntity.repulseEnabled)
                {
                    pEntity.dx += Math.cos(angle) * power * repulseForce;
                    pEntity.dy += Math.sin(angle) * power * repulseForce;
                }
            }
            return true;
        }
        return false;
    }
}

