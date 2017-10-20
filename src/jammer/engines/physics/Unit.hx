package jammer.engines.physics;

import flash.errors.Error;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.display.types.JamDisplayObject;
import jammer.engines.level.Level;
import jammer.utils.MathUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Unit extends Entity
{
    private var history : Array<Dynamic>;
    
    public static inline var LEFT : String = "left";
    public static inline var RIGHT : String = "right";
    public static inline var UP : String = "up";
    public static inline var DOWN : String = "down";
    
    
    public var friction : Float;
    public var gravity : Float;
    
    public var speedX : Float;
    public var speedY : Float;
    public var dirX : Float;
    public var dirY : Float;
    public var lastDirX : Float;
    public var lastDirY : Float;
    public var dir : String;
    
    public var lastdx : Float;
    public var lastdy : Float;
    public var speed : Float;
    public var direction : Float;
    public var deltaJump : Float;
    public var jump : Float;
    public var askJump : Bool;
    public var canJump : Bool;
    public var frictionJump : Float;
    
    public var life : Float;
    public var domagesTaken : Float;
    public var hurted : Bool;
    
    public var xrMin : Float;
    public var xrMax : Float;
    public var yrMin : Float;
    public var yrMax : Float;
    
    public var xrMin2 : Float;
    public var xrMax2 : Float;
    public var yrMin2 : Float;
    public var yrMax2 : Float;
    public var isLevelCollide : Bool;
    
    
    public function new(pSkin : JamDisplayObject)
    {
        skin = pSkin;
        super(skin);
    }
    
    override public function reset() : Void
    {
        super.reset();
        gravity = 0.12;
        friction = 0.75;
        xr = yr = dx = dy = x = y = cx = cy = 0;
        speed = speedX = speedY = 0;
        deltaJump = 0;
        jump = 0.26;
        askJump = false;
        canJump = false;
        frictionJump = 0.91;
        dirX = dirY = lastdx = lastdy = 0;
        speed = 0.03;
        history = [];
        xrMin = yrMin = 0.5;
        xrMax = yrMax = 0.5;
        life = 20;
        dead = false;
        xrMin2 = yrMin2 = 0.4;
        xrMax2 = yrMax2 = 0.6;
        lastDirX = lastDirY = 0;
        domagesTaken = 0;
    }
    
    public function setDomages(pDomages : Float) : Void
    {
        if (life <= 0)
        {
            return;
        }
        hurted = true;
        domagesTaken += pDomages;
    }
    
    public function command(pDelta : Float = 1.0) : Void
    {
    }
    
    public function execute(pDelta : Float = 1.0) : Void
    {
        if (level == null)
        {
            new Error("Level attribut missing in Unit " + this);
        }
        isLevelCollide = false;
        
        if (canJump && askJump)
        {
            deltaJump = jump;
        }
        canJump = false;
        
        
        if (dirX != 0 || dirY != 0)
        {
            direction = Math.atan2(dirY, dirX);
            //if(dirX != 0)lastDirX = dirX;
            //if(dirY != 0)lastDirY = dirY;
            if (dirX != 0 || dirY != 0)
            {
                lastDirX = dirX;
                lastDirY = dirY;
            }
            dx += Math.cos(direction) * (speed + speedX);
            dy += Math.sin(direction) * (speed + speedY);
        }
        
        dy += gravity;
        dy -= deltaJump;
        
        
        
        xr += dx;
        if (xr < xrMin)
        {
            if (level.hasCollision(cx - 1, cy))
            {
                xr = xrMin;
                dx = 0;
                isLevelCollide = true;
            }
            else
            {
                if (yr < yrMin2 && level.hasCollision(cx - 1, cy - 1) || yr > yrMax2 && level.hasCollision(cx - 1, cy + 1))
                {
                    xr = xrMin;
                    dx = 0;
                    isLevelCollide = true;
                }
            }
        }
        if (xr > xrMax)
        {
            if (level.hasCollision(cx + 1, cy))
            {
                xr = xrMax;
                dx = 0;
                isLevelCollide = true;
            }
            else
            {
                if (yr > yrMax2 && level.hasCollision(cx + 1, cy + 1) || yr < yrMin2 && level.hasCollision(cx + 1, cy - 1))
                {
                    xr = xrMax;
                    dx = 0;
                    isLevelCollide = true;
                }
            }
        }
        
        yr += dy;
        if (yr < yrMin)
        {
            if (level.hasCollision(cx, cy - 1))
            {
                yr = yrMin;
                dy = 0;
                isLevelCollide = true;
            }
            else
            {
                if (xr < xrMin2 && level.hasCollision(cx - 1, cy - 1) || xr > xrMax2 && level.hasCollision(cx + 1, cy - 1))
                {
                    yr = yrMin;
                    dy = 0;
                    isLevelCollide = true;
                }
            }
        }
        if (yr > yrMax)
        {
            if (level.hasCollision(cx, cy + 1))
            {
                yr = yrMax;
                dy = 0;
                canJump = true;
                deltaJump = 0;
                isLevelCollide = true;
            }
            else
            {
                if (xr > xrMax2 && level.hasCollision(cx + 1, cy + 1) || xr < xrMin2 && level.hasCollision(cx - 1, cy + 1))
                {
                    yr = yrMax;
                    dy = 0;
                    canJump = true;
                    deltaJump = 0;
                    isLevelCollide = true;
                }
            }
        }
        
        while (xr > 1)
        {
            xr--;cx++;
        }
        while (xr < 0)
        {
            xr++;cx--;
        }
        while (yr > 1)
        {
            yr--;cy++;
        }
        while (yr < 0)
        {
            yr++;cy--;
        }
        
        dx *= friction;
        if (MathUtils.fabs(dx) <= 0.005)
        {
            dx = 0;
        }
        
        dy *= friction;
        if (MathUtils.fabs(dy) <= 0.005)
        {
            dy = 0;
        }
        
        deltaJump *= frictionJump;
        if (MathUtils.fabs(deltaJump) <= 0.02)
        {
            deltaJump = 0;
        }
        
        if (dx != 0)
        {
            lastdx = dx;  //>0?1:-1;  ;
        }
        if (dy != 0)
        {
            lastdy = dy;  //>0?1:-1;  ;
        }
        
        askJump = false;
        
        
        x = Std.int(level.tileWidth * (cx + xr));
        y = Std.int(level.tileHeight * (cy + yr));
        skin.x = x - skin.centerX;
        skin.y = y - skin.centerY;
        
        if (hurted)
        {
            life -= domagesTaken;
            hurted = false;
            domagesTaken = 0;
            if (life <= 0)
            {
                life = 0;
                destruct();
            }
        }
    }
    
   override inline public function update(pDelta : Float = 1.0) : Void
    {
        this.command(pDelta);
        this.execute(pDelta);
    }
}

