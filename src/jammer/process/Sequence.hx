package jammer.process;

import haxe.Constraints.Function;
import flash.events.VideoEvent;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Sequence extends Process
{
    
    private var _actions : Array<(Int->Void)->Void>;
    private var _cooldown : Float;
    
    public function new(pActions : Array<(Int->Void)->Void>, pPriority : Int = 0, pName : String = "")
    {
        super(pPriority, pName);
        _actions = pActions;
        paused = true;
        _cooldown = 0;
    }
    
    public function start() : Void
    {
        paused = false;
    }
	
	public function _cb(pDelay:Int):Void{
		_cooldown = pDelay;
		paused = false;
	}
    
    override public function run(pDelta : Float = 1.0) : Void
    {
        if (_cooldown <= 0)
        {
            var action : Function = _actions.shift();
            if (action != null)
            {
				paused = true;
                action(_cb);
				
            }
            else
            {
                destroyed = true;
            }
        }
        else
        {
            _cooldown -= pDelta;
        }
    }
    

    public inline static function create(pActions : Array<(Int->Void)->Void>) : Sequence
    {
        var seq : Sequence = new Sequence(pActions);
        seq.paused = false;
        return seq;
    }
    
    override public function toString() : String
    {
        return "[Sequence name=" + name + " priority=" + _priority + " FPS=" + Process.FPS + " ]";
    }
}

