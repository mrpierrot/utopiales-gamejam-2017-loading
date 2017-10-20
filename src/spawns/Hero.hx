package spawns;

import jammer.controls.Key;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.physics.Unit;
import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Hero extends Unit
{
    
    public var halo : JamAnimation;
    public var hit : Bool;
    public var domages : Float;
    
    public function new()
    {
        super(AssetsManager.instance.createAnimation("human"));
		
		halo = AssetsManager.instance.createAnimation("human");
		halo.frameData.asset = AssetsManager.instance.createSprite("halo").frameData.asset;
        
        
        
        cast((skin), JamAnimation).registerStateCondition("runRight", function() : Bool
                {
                    return dirX > 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("runLeft", function() : Bool
                {
                    return dirX < 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("runDown", function() : Bool
                {
                    return dirY > 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("runUp", function() : Bool
                {
                    return dirY < 0;
                });
        
        
        
        cast((skin), JamAnimation).registerStateCondition("staticDown", function() : Bool
                {
                    return lastDirY > 0 && dirX == 0 && dirY == 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("staticUp", function() : Bool
                {
                    return lastDirY < 0 && dirX == 0 && dirY == 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("staticLeft", function() : Bool
                {
                    return lastDirX < 0 && dirX == 0 && dirY == 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("staticRight", function() : Bool
                {
                    return lastDirX > 0 && dirX == 0 && dirY == 0;
                });
        
        cast((skin), JamAnimation).onRender = function():Void {
			halo.state = cast((skin), JamAnimation).state;
			//trace(halo.state);
			halo.x = skin.x;
			halo.y = skin.y;
		}
        
        xrMin = xrMin2 = 0.3;
        xrMax = xrMax2 = 0.7;
        yrMin = yrMin2 = 0;
        yrMax = yrMax2 = 0.5;
        speed *= 2;
        collisionEnabled = true;
        //repulseEnabled = false;
        repulseEnabled = true;
        //repulseForce *= 4;
        gravity = 0;
        domages = 0.7;
        
        
        skin.frameData.asset.applyFilter(skin.frameData.asset, skin.frameData.asset.rect, new Point(), new GlowFilter(0, 0.2, 2, 2, 2, 1, false));
    }
    
    override public function command(pDelta : Float = 1.0) : Void
    {
        dirX = dirY = 0;
        hit = false;
        if (Key.isDown(Key.UP))
        {
            dirY -= 1;
        }
        if (Key.isDown(Key.DOWN))
        {
            dirY += 1;
        }
        if (Key.isDown(Key.LEFT))
        {
            dirX -= 1;
        }
        if (Key.isDown(Key.RIGHT))
        {
            dirX += 1;
        }
        
        if (Key.isDown(Key.SPACE))
        {
            hit = true;
        }
        
        //jam_info_write("dirX", dirX);
        //jam_info_write("dirY", dirY);
        
        super.command(pDelta);
        /*if (hit) {
				Fx.slash(skin, direction);
			}*/
        //jam_info_write("lastDirX", lastDirX);
        //jam_info_write("lastDirY", lastDirY);
    }
}

