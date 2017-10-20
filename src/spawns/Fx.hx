package spawns;

import flash.display.PixelSnapping;
import haxe.Constraints.Function;
import jammer.Context;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.particles.Particle;
import jammer.engines.display.particles.ParticlesContainer;
import jammer.engines.display.types.JamDisplayObject;
import jammer.utils.MathUtils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.filters.GlowFilter;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Fx
{
    
    
    public function new()
    {
    }
    
    
    public inline static function sparks(pX : Int, pY : Int, pDir : Float) : Void
    {
        var i : Int = 0;
        var c : Int = 10;
        while (i < c)
        {
            var p : Particle = Context.game.particles.createParticle(Std.int(pX + MathUtils.irnd(0, 1) + pDir * 7), Std.int(pY + MathUtils.rnd(0, 10)));
            p.drawBox(1, 1, 0xFFCC00, MathUtils.rnd(0.4, 1));
            p.dx = MathUtils.rnd(0.1, 0.3) * (-pDir);
            p.gravityX = MathUtils.signRnd(0, 0.03);
            //p.dy = -MathUtils.rnd(1,4);
            p.frictX = p.frictY = 0.9;
            p.gravityY = MathUtils.rnd(0.1, 0.4);
            //p.groundY = pY
            p.life = MathUtils.irnd(2, 8);
            p.filters = [new GlowFilter(0xDE533A, 1, 4, 4, 2)];
            i++;
        }
    }
    
    
    
    private static var _tempoSlash : Int = 0;
    
    public inline static function slash(target : JamDisplayObject, pDir : Float) : Void
    {
        if (!target.visible)
        {
            return;
        }
        if ((++_tempoSlash) % 6 != 0)
        {
            return;
        }
        //trace(AssetsManager.instance.getAsset("slash"));
        var bmp : Bitmap = new Bitmap(AssetsManager.instance.getAsset("slash").data, PixelSnapping.AUTO, true);
        bmp.x = -bmp.width * 0.5;
        bmp.y = -bmp.height * 0.5;
        var p : Particle = Context.game.particles.createParticle(8, 8);
        p.target = target;
        p.rotation = MathUtils.rnd((pDir * MathUtils.RAD_2_DEG) - 45, (pDir * MathUtils.RAD_2_DEG) + 45);
        p.addChild(bmp);
        p.dx = 0;
        p.dy = 0;
        p.pixelSnapping = true;
        p.gravityX = 0;
        p.gravityY = 0;
        p.alpha = 0.6;  //MathUtils.rnd(0.3, 1);  ;
        p.life = 2;
        p.blendMode = BlendMode.HARDLIGHT;
    }
    
    private static var line : GlowFilter = new GlowFilter(0, 1, 2, 2, 1, 1, false);
    


    public inline static function cubeHurted(pX : Int, pY : Int, target : JamDisplayObject, pOnKill : Function) : Void
    {
        if (!target.visible)
        {
            return;
        }
        var i : Int = 0;
        var c : Int = MathUtils.irnd(0, 1);
        while (i < c)
        {
            var p : Particle = Context.game.particles.createParticle(pX + target.x + MathUtils.irnd(0, 16), pY + target.y);
            //p.target = target;
            var r : Float = MathUtils.irnd(1, 3);
            p.drawBox(r, r, 0x8ffdab, /*0x31e760*/MathUtils.rnd(0.4, 1));
            p.dx = MathUtils.signRnd(0.1, 1.5);
            p.gravityX = MathUtils.signRnd(0, 0.03);
            p.dy = -MathUtils.rnd(2, 8);
            p.frictX = p.frictY = 0.9;
            p.gravityY = MathUtils.rnd(1, 2);
            p.groundY = pY + target.y + 14;
            p.bounce = 0.2;
            p.alpha = 1;
            p.onKill = pOnKill;
            p.life = MathUtils.irnd(14, 16);
            p.fadeOutSpeed = 1;
            p.blendMode = BlendMode.HARDLIGHT;
            p.filters = [line];
            i++;
        }
    }
    


    public inline static function cubeDead(pX : Int, pY : Int, target : JamDisplayObject, pOnKill : Function) : Void
    {
        if (!target.visible)
        {
            return;
        }
        var i : Int = 0;
        var c : Int = MathUtils.irnd(20, 40);
        while (i < c)
        {
            var p : Particle = Context.game.particles.createParticle(pX + target.x + MathUtils.irnd(0, 16), pY + target.y + 8);
            //p.target = target;
            var r : Float = MathUtils.irnd(1, 3);
            p.drawBox(r, r, 0x8ffdab, /*0x31e760*/MathUtils.rnd(0.4, 1));
            p.dx = MathUtils.signRnd(0.5, 5);
            p.gravityX = MathUtils.signRnd(0, 0.03);
            p.dy = -MathUtils.rnd(4, 12);
            p.frictX = p.frictY = 0.9;
            p.gravityY = MathUtils.rnd(0.5, 1.5);
            //p.groundY = pY+target.y + 14;
            p.bounce = 0.2;
            p.alpha = 1;
            p.onKill = pOnKill;
            p.life = MathUtils.irnd(10, 12);
            p.fadeOutSpeed = 1;
            p.blendMode = BlendMode.HARDLIGHT;
            p.filters = [line];
            i++;
        }
    }
}
