package jammer.utils;

import flash.geom.Point;


class MathUtils
{
    
    public function new()
    {
    }
	
	public inline static var INT32_MAX: Int = 2147483647;
    
    /**
		 * Multiply value by this constant to convert from radians to degrees.
		 */
    

    public inline static var RAD_2_DEG : Float = 180 / PI;
    
    /**
		 * Multiply value by this constant to convert from degrees to radians.
		 */
    

    public inline static var DEG_2_RAD : Float = PI / 180;
    
    /**
		 * The natural logarithm of 2.
		 */
    

    public inline static var LN2 : Float = 0.6931471805599453;
    
    /**
		 * Math.PI / 2.
		 */
    

    public inline static var PIHALF : Float = 1.5707963267948966;
    
    /**
		 * Math.PI.
		 */
    

    public inline static var PI : Float = 3.141592653589793;
    
    /**
		 * 2 * Math.PI.
		 */
    

    public inline static var PI2 : Float = 6.283185307179586;
    
    /**
		 * Default system epsilon.
		 */
    

    public inline static var EPS : Float = 1e-6;
    
    /**
		 * The square root of 2.
		 */
    

    public inline static var SQRT2 : Float = 1.414213562373095;
    
    /**
		 * Fast replacement for Math.round(x).
		 */
    

    public inline static function round(x : Float) : Int
    {
        return Std.int((x > 0) ? x + .5 : (x < 0) ? x - .5 : 0);
    }
    
    /**
		 * Fast replacement for Math.ceil(x).
		 */
    

    public inline static function ceil(x : Float) : Int
    {
        var t : Int;
        if (x > .0)
        {
            t = Std.int(x + .5);
            return ((t < x)) ? t + 1 : t;
        }
        else
        {
            if (x < .0)
            {
                t = Std.int(x - .5);
                return ((t < x)) ? t + 1 : t;
            }
            else
            {
                return 0;
            }
        }
    }
    
    /**
		 * Fast replacement for Math.floor(x).
		 */
    

    public inline static function floor(x : Float) : Int
    {
		var ret:Int = 0;
        if (x >= 0)
        {
            ret =  Std.int(x);
        }
        else
        {
            var i : Int = Std.int(x);
            if (x == i)
            {
                ret = i;
            }
            else
            {
                ret = Std.int(i - 1);
            }
        }
        return ret;
    }
    
    /**
		 * Returns min(x, y).
		 */
    

    public inline static function min(x : Int, y : Int) : Int
    {
        return (x < y) ? x : y;
    }
    
    /**
		 * Returns max(x, y).
		 */
    

    public inline static function max(x : Int, y : Int) : Int
    {
        return (x > y) ? x : y;
    }
    
    /**
		 * Returns min(x, y).
		 */
    

    public inline static function fmin(x : Float, y : Float) : Float
    {
        return (x < y) ? x : y;
    }
    
    /**
		 * Returns max(x, y).
		 */
    

    public inline static function fmax(x : Float, y : Float) : Float
    {
        return (x > y) ? x : y;
    }
    
    /**
		 * Returns the absolute value of x.
		 */
    

    public inline static function iabs(x : Int) : Int
    {
        return (x < 0) ? -x : x;
    }
    
    
    /**
		 * Returns the absolute value of x.
		 */
    

    public inline static function fabs(x : Float) : Float
    {
        return (x < 0) ? -x : x;
    }
    
    

    public inline static function squareDistance(pAx : Float, pAy : Float, pBx : Float, pBy : Float) : Float
    {
        var gx : Float = pBx - pAx;
        var gy : Float = pBy - pAy;
        return gx * gx + gy * gy;
    }
    
    

    public inline static function intSquareDistance(pAx : Int, pAy : Int, pBx : Int, pBy : Int) : Int
    {
        var gx : Int = Std.int(pBx - pAx);
        var gy : Int = Std.int(pBy - pAy);
        return Std.int(gx * gx + gy * gy);
    }
    
    

    public inline static function distance(pAx : Float, pAy : Float, pBx : Float, pBy : Float) : Float
    {
        var gx : Float = pBx - pAx;
        var gy : Float = pBy - pAy;
        return Math.sqrt(gx * gx + gy * gy);
    }
    
    

    public inline static function barycenter(pPointA : Point, pPointB : Point, pMassA : Float = 1, pMassB : Float = 1) : Point
    {
        var ret : Point = new Point();
        ret.x = (pMassA * pPointA.x + pMassB * pPointB.x) / (pMassA + pMassB);
        ret.y = (pMassA * pPointA.y + pMassB * pPointB.y) / (pMassA + pMassB);
        return ret;
    }
    
    

    public inline static function sign() : Int
    {
        return Std.int(Std.int(Math.random() * 2) * 2 - 1);
    }
    
    

    public inline static function rnd(min : Float, max : Float) : Float
    {
        return min + Math.random() * (max - min);
    }
    
    

    public inline static function signRnd(min : Float, max : Float) : Float
    {
        return (min + Math.random() * (max - min)) * sign();
    }
    
    
    

    public inline static function irnd(min : Int, max : Int) : Int
    {
        return Std.int(min + Std.int(Math.random() * (max - min + 1)));
    }
    
    

    public inline static function iSignRnd(min : Int, max : Int) : Int
    {
        return Std.int((min + Std.int(Math.random() * (max - min + 1))) * sign());
    }
    
    /**
		 * Compares x and y using an absolute tolerance of eps.
		 */
    

    public inline static function compareAbs(x : Float, y : Float, eps : Float) : Bool
    {
        var d : Float = x - y;
        return (d > 0) ? d < eps : -d < eps;
    }
    
    /**
		 * 
		 * @param	t 0->1
		 * @param	p0
		 * @param	p1
		 * @param	p2
		 * @param	p3
		 */
    

    public inline static function bezierCubic(t : Float, p0 : Float, p1 : Float, p2 : Float, p3 : Float) : Float
    {
        return (1 - t) * (1 - t) * (1 - t) * p0 +
        3 * t * (1 - t) * (1 - t) * p1 +
        3 * t * t * (1 - t) * p2 +
        t * t * t * p3;
    }
    
    

    public inline static function bezierQuadric(t : Float, p0 : Float, p1 : Float, p2 : Float) : Float
    {
        return (1 - t) * (1 - t) * p0 +
        2 * t * (1 - t) * p1 +
        t * t * p2;
    }
}

