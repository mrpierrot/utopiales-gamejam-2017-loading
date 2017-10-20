package jammer.engines.display.camera;

import haxe.Constraints.Function;
import jammer.process.JamTween;
import jammer.utils.MathUtils;
import com.greensock.easing.Cubic;
import com.greensock.easing.SlowMo;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class CameraTweenMovement implements ICameraMovementStrategy
{
    
    private var _minSqrtDistMovement : Int;
    
    public var easing : Function;
    public var frictions : Float;
    
    public function new(pEasing : Function = null, pMinDistMovement : Int = 10)
    {
        easing = pEasing;
        _minSqrtDistMovement = Std.int(pMinDistMovement * pMinDistMovement);
    }
    
    
    
    public function update(pCamera : Camera, pDestX : Int, pDestY : Int) : Void
    {
        /*var sqrtDist:int = MathUtils.intSquareDistance(pDestX,pDestY, pCamera.x, pCamera.y)
			if( sqrtDist >=_minSqrtDistMovement ) {
				pCamera.dx += (pDestX - pCamera.x) * speed;
				pCamera.dy += (pDestY - pCamera.y) * speed;
			}else if (sqrtDist < 100 ) {
				pCamera.dx = 0;
				pCamera.dy = 0;
			}

			pCamera.x+=pCamera.dx;
			pCamera.y+=pCamera.dy;
			if( MathUtils.fabs(pCamera.dx)<=0.05 )
				pCamera.dx = 0;
			if( MathUtils.fabs(pCamera.dy)<=0.05 )
				pCamera.dy = 0;
		



			pCamera.dx*=frictions;
			pCamera.dy*=frictions;*/
        var sqrtDist : Int = MathUtils.intSquareDistance(pDestX, pDestY, pCamera.x, pCamera.y);
        if (sqrtDist >= _minSqrtDistMovement)
        {
            JamTween.to(pCamera, 90, {
                        x : pDestX,
                        y : pDestY
                    }, easing);
        }
    }
}

