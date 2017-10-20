package jammer.engines.display;

import jammer.engines.display.particles.Particle;
import jammer.engines.display.particles.ParticlesContainer;
import jammer.utils.MathUtils;
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
    
    
    public static function sparks(pParticlesContainer : ParticlesContainer, pX : Int, pY : Int, pDir : Float) : Void
    {
        var i : Int = 0;
        var c : Int = 10;
        while (i < c)
        {
            var p : Particle = pParticlesContainer.createParticle(Std.int(pX + MathUtils.rnd(0, 1) + pDir * 7), pY + MathUtils.irnd(0, 10));
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
    
    
    public static function glue(pParticlesContainer : ParticlesContainer, pX : Int, pY : Int, pDir : Float) : Void
    {
        var i : Int = 0;
        var c : Int = 4;
        while (i < c)
        {
            var p : Particle = pParticlesContainer.createParticle(Std.int(pX + MathUtils.rnd(0, 16) + pDir * 7), pY);
            p.drawCircle(MathUtils.rnd(1, 2), 0x8ce731, MathUtils.rnd(0.4, 1));
            p.dx = MathUtils.rnd(0.1, 0.3) * (-pDir);
            p.gravityX = MathUtils.signRnd(0, 0.03);
            p.dy = MathUtils.rnd(1, 4);
            p.frictX = p.frictY = 0.9;
            p.gravityY = -MathUtils.rnd(0.1, 1);
            p.groundY = pY + 2;
            p.bounce = 0.1;
            p.alpha = 0.5;
            p.life = MathUtils.irnd(2, 4);
            p.blendMode = BlendMode.NORMAL;
            p.filters = [new GlowFilter(0x52ad00, 1, 2, 2, 10)];
            i++;
        }
    }
}

