package jammer.engines.display.particles;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class ParticlesEnvironnement
{
    
    public static var DEFAULT : ParticlesEnvironnement = new ParticlesEnvironnement();
    
    public var gravityX : Float = 0;
    public var gravityY : Float = 0.4;
    public var wind : Bool = false;
    public var windX : Float = 0;
    public var windY : Float = 0;
    
    public function new()
    {
    }
}

