package jammer.engines.lights;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LightSource
{
    
    
    public var x : Int;
    public var y : Int;
    public var distance : Int;
    public var intensity : Float;
    public var color : Int;
    
    public function new(pX : Int = 0, pY : Int = 0, pDistance : Int = 5, pColor : Int = 0xf9f8ce, pIntensity : Float = 1)
    {
        distance = pDistance;
        x = pX;
        y = pY;
        color = pColor;
        intensity = pIntensity;
    }
    
    public function toString() : String
    {
        return "[Light x=" + x + " y=" + y + " distance=" + distance + " intensity=" + intensity + " color=" + color +
        "]";
    }
}

