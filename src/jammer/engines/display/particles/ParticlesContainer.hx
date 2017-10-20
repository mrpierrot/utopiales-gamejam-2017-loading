package jammer.engines.display.particles;

import haxe.Constraints.Function;
import jammer.collections.LinkedList;
import jammer.collections.Node;
import jammer.collections.NodePool;
import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamFlashSprite;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class ParticlesContainer extends JamFlashSprite
{
    
    public var pool : LinkedList;
    public var limit : Int = 1000;
    public var env : ParticlesEnvironnement;
    
    public function new()
    {
        super();
        pool = new LinkedList(new NodePool(Particle));
        env = new ParticlesEnvironnement();
    }
    
    public function createParticle(pX : Int, pY : Int) : Particle
    {
        var node : Node = pool.create();
        var particle : Particle = node.data;
        particle.node = node;
        particle.reset(pX, pY, env);
        sprite.addChild(particle);
        return particle;
    }
    
    @:meta(Inline())

    @:final override public function getFrameData(pFrame : Int) : FrameData
    {
        var i : Int = 0;
        var wx : Float = env.windX;
        var wy : Float = env.windY;
        var node : Node = pool.head;
        while (node != null)
        {
            var p : Particle = node.data;
            var wind : Int = ((p.windAffect) ? 1 : 0);
            p.delay--;
            if (p.delay > 0)
            {
                node = node.next;
            }
            else
            {
                if (p.onStart != null)
                {
                    var cb : Function = p.onStart;
                    p.onStart = null;
                    cb(p);
                }
                // gravité
                p.dx += p.gravityX + wind * wx;
                p.dy += p.gravityY + wind * wy;
                
                // friction
                p.dx *= p.frictX;
                p.dy *= p.frictY;
                
                // mouvement
                p.xx += p.dx;
                p.yy += p.dy;
                
                
                // Ground
                if (!Math.isNaN(p.groundY) && p.dy > 0 && ((p.target != null) ? p.target.y + p.yy : p.yy) >= p.groundY)
                {
                    p.dy = -p.dy * p.bounce;
                    p.yy = p.groundY - 1;
                    if (p.onBounce != null)
                    {
                        p.onBounce(p);
                    }
                }
                
                // Display coords
                if (p.pixelSnapping)
                {
                    p.x = (p.target != null) ? p.target.x + Std.int(p.xx) : Std.int(p.xx);
                    p.y = (p.target != null) ? p.target.y + Std.int(p.yy) : Std.int(p.yy);
                }
                else
                {
                    p.x = (p.target != null) ? p.target.x + p.xx : p.xx;
                    p.y = (p.target != null) ? p.target.y + p.yy : p.yy;
                }
                
                if (p.deltaRotation != 0)
                {
                    p.rotation += p.deltaRotation;
                }
                if (p.deltaScale != 0 || p.deltaScaleX != 0)
                {
                    p.scaleX += p.deltaScale + p.deltaScaleX;
                }
                if (p.deltaScale != 0 || p.deltaScaleX != 0)
                {
                    p.scaleY += p.deltaScale + p.deltaScaleY;
                }
                
                
                // Fade in
                if (p.life > 0 && p.deltaAlpha != 0)
                {
                    p.alpha += p.deltaAlpha;
                    if (p.alpha > 1)
                    {
                        p.deltaAlpha = 0;
                        p.alpha = 1;
                    }
                }
                
                p.life--;
                
                // Fade out (life)
                if (p.life <= 0)
                {
                    p.alpha -= p.fadeOutSpeed;
                }
                
                // Death
                if (p.life <= 0 && (p.alpha <= 0 || p.fadeOutSpeed == 0))
                {
                    if (p.onKill != null)
                    {
                        p.onKill(p);
                        p.onKill = null;
                        node = node.next;
                    }
                    else
                    {
                        if (p.parent != null)
                        {
                            p.parent.removeChild(p);
                        }
                        var next : Node = node.next;
                        pool.remove(node);
                        node = next;
                    }
                }
                else
                {
                    if (p.onUpdate != null)
                    {
                        p.onUpdate(p);
                    }
                    node = node.next;
                }
            }
        }
        
        return super.getFrameData(pFrame);
    }
}

