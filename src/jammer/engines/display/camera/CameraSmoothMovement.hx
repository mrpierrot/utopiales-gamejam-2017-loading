package jammer.engines.display.camera;

import jammer.process.JamTween;
import jammer.utils.MathUtils;
//import com.greensock.easing.Cubic;
//import com.greensock.easing.SlowMo;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class CameraSmoothMovement implements ICameraMovementStrategy
{
    
    private var _minSqrtDistMovement : Int;
    
    public var speed : Float;
    public var frictions : Float;
    
    public function new(pSpeed : Float = 0.040, pMinDistMovement : Int = 10, pFrictions : Float = 0.85)
    {
        speed = pSpeed;
        frictions = pFrictions;
        _minSqrtDistMovement = Std.int(pMinDistMovement * pMinDistMovement);
    }
    
    
    
    public function update(pCamera : Camera, pDestX : Int, pDestY : Int) : Void
    {
        var sqrtDist : Int = MathUtils.intSquareDistance(pDestX, pDestY, pCamera.x, pCamera.y);
        if (sqrtDist >= _minSqrtDistMovement)
        {
            pCamera.dx += (pDestX - pCamera.x) * speed;
            pCamera.dy += (pDestY - pCamera.y) * speed;
        }
        else
        {
            if (sqrtDist < 100)
            {
                pCamera.dx = 0;
                pCamera.dy = 0;
            }
        }
        
        pCamera.x += Std.int(pCamera.dx);
        pCamera.y += Std.int(pCamera.dy);
        if (MathUtils.fabs(pCamera.dx) <= 0.05)
        {
            pCamera.dx = 0;
        }
        if (MathUtils.fabs(pCamera.dy) <= 0.05)
        {
            pCamera.dy = 0;
        }
        
        
        pCamera.dx *= frictions;
        pCamera.dy *= frictions;
    }
}

