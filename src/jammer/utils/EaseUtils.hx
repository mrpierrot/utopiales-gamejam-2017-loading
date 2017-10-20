package jammer.utils;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class EaseUtils
{
    
    public function new()
    {
    }
    
    @:meta(Inline())

    public static function easeLinear(pRate : Float) : Float
    {
        return pRate;
    }
    
    /**
		 * accelerating from zero velocity
		 * @param	pRate
		 * @return
		 */
    @:meta(Inline())

    public static function easeInQuad(pRate : Float) : Float
    {
        return pRate * pRate;
    }
    
    /**
		 * decelerating to zero velocity
		 * @param	pRate
		 * @return
		 */
    @:meta(Inline())

    public static function easeOutQuad(pRate : Float) : Float
    {
        return -1 * pRate * (pRate - 2);
    }
    
    /**
		 * accelerating from zero velocity
		 * @param	pRate
		 * @return
		 */
    @:meta(Inline())

    public static function easeInCubic(pRate : Float) : Float
    {
        return pRate * pRate * pRate;
    }
    
    /**
		 * decelerating to zero velocity
		 * @param	pRate
		 * @return
		 */
    @:meta(Inline())

    public static function easeOutCubic(pRate : Float) : Float
    {
        pRate--;
        return pRate * pRate * (pRate + 1);
    }
    
    /**
		 * 
		 * @param	pRate
		 * @return
		 */
    @:meta(Inline())

    public static function easeInSine(pRate : Float) : Float
    {
        return -1 * Math.cos(pRate * MathUtils.PIHALF);
    }
    
    /**
		 * 
		 * @param	pRate
		 * @return
		 */
    @:meta(Inline())

    public static function easeOutSine(pRate : Float) : Float
    {
        return Math.sin(pRate * MathUtils.PIHALF);
    }
}

