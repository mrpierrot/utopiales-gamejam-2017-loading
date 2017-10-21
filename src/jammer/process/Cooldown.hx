package jammer.process;

import haxe.Constraints.Function;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Cooldown extends Process
{
    private var _map : Map<String,Dynamic>;
    
    public function new(pPriority : Int = 0, pName : String = null)
    {
        super(pPriority, pName);
        _map = new Map<String,Dynamic>();
    }
    
    public function add(pName : String, pCount : Int, pCallback : Function = null) : Void
    {
        _map[pName] = {
                    count : pCount,
                    callback : pCallback
                };
    }
    
    public function has(pName : String) : Bool
    {
        return _map.exists(pName);
    }
    
    public function remove(pName : String) : Void
    {
        _map.remove(pName);
    }
    
    override public function run(pDelta : Float = 1.0) : Void
    {
        var cd : Dynamic;
        for (name in _map.keys())
        {
            cd = _map[name];
            if (cd.count - pDelta <= 0)
            {
                _map.remove(name);
                if (cd.callback != null)
                {
                    cd.callback();
                }
            }
            else
            {
                cd.count -= pDelta;
            }
        }
    }
    
    override public function toString() : String
    {
        return "[Cooldown name=" + name + " priority=" + _priority + " FPS=" + Process.FPS + " ]";
    }
}

