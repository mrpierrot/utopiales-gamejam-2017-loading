package spawns;

import jammer.controls.Key;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.assets.TileSetAsset;
import jammer.engines.display.Fx;
import jammer.engines.display.fx.Flash;
import jammer.engines.display.particles.Particle;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.display.types.JamBitmap;
import jammer.engines.physics.PathUnit;
import jammer.engines.physics.Unit;
import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Mob extends PathUnit
{
    
    
    private var splashTiles : TileSetAsset;
    private var _destPoint : Point;
    public static var splashLayer : JamBitmap;
    public var flash : Flash;
    
    public function new()
    {
        super(AssetsManager.instance.createAnimation("human"));
        //splashTiles = AssetsManager.instance.getTileSetAsset("tiles");
        _destPoint = new Point();
        skin.color = new ColorTransform();
        skin.transformEnabled = true;
        flash = new Flash(skin.color, 0.7, 0.3);

        
        
        //halo = JamAnimation(skin.clone(true));
        
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
                    return cast((skin), JamAnimation).state == "runDown" && dy == 0 && dx == 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("staticUp", function() : Bool
                {
                    return cast((skin), JamAnimation).state == "runUp" && dy == 0 && dx == 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("staticLeft", function() : Bool
                {
                    return cast((skin), JamAnimation).state == "runLeft" && dy == 0 && dx == 0;
                });
        
        cast((skin), JamAnimation).registerStateCondition("staticRight", function() : Bool
                {
                    return cast((skin), JamAnimation).state == "runRight" && dy == 0 && dx == 0;
                });
				
		  cast((skin), JamAnimation).onRender = function():Void {
			//trace("pouet");
		}
    }
    
    override public function reset() : Void
    {
        super.reset();
        xrMin = xrMin2 = 0.3;
        xrMax = xrMax2 = 0.7;
        yrMin = yrMin2 = 0;
        yrMax = yrMax2 = 0.8;
        xr = yr = 0.5;
        speed *= 0.5;
        //speed *= 2;
        collisionEnabled = true;
        repulseEnabled = true;
        repulseForce /= 4;
        targetMode = true;
        radius = 4;
        //skin.color = new ColorTransform(1, 1, 1, 0.8)
        //skin.blendMode = BlendMode.HARDLIGHT;
        //skin.transformEnabled = true;
        //skin.rotate(0.3);
        gravity = 0;
    }
    
    override public function execute(pDelta : Float = 1.0) : Void
    {
        if (hurted)
        {
            flash.start();
           // Fx.cubeHurted(0, 0, this.skin, _onCubeFleshDestroyed);
        }
        flash.update();
        super.execute(pDelta);
		

		//skin.visible = level.getCell(cx, cy).discovered > 0.2;
		//trace(level.getCell(cx, cy).discovered > 0.2);
		skin.visible = level.getCell(cx, cy).discovered > 0.2;
    }
    
    override public function destruct() : Void
    {
        skin.remove();
        //Fx.cubeDead(0, 0, this.skin, _onCubeFleshDestroyed);
        super.destruct();
    }
    
    private inline function _onCubeFleshDestroyed(pParticle : Particle) : Void
    {
        /*var rect : Rectangle = splashTiles.getRandomTile("splash");
        _destPoint.x = pParticle.x - rect.width * 0.5;
        _destPoint.y = pParticle.y - rect.height * 0.5;
        splashLayer.bitmapData.copyPixels(splashTiles.data, rect, _destPoint, null, null, true);*/
    }
}
