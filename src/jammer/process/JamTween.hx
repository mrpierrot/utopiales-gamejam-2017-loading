package jammer.process;

import haxe.Constraints.Function;
import jammer.collections.Pool;
import jammer.process.Process;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamTween extends Process
{
    
    public static var pool : Pool = new Pool(JamTween, 10, 10);
    private static var _map : Map<String,Dynamic> = new Map<String,Dynamic>();
    
    private var _target : Dynamic;
    private var _data : Dynamic;
    private var _duration : Int;
    private var _value : Float;
    private var _ease : Function;
    private var _startValues : Map<String,Dynamic>;
    public var onUpdate : Function;
    
    
    public function new(pTarget : Dynamic = null, pDuration : Int = 0, pData : Dynamic = null, pPriority : Int = -10, pName : String = "Tween")
    {
        _target = pTarget;
        _data = pData;
        _duration = lifeTime = pDuration;
        _value = 0;
        _startValues = new Map<String,Dynamic>();
        super(pPriority, pName, false);
    }
    
    
    override public function destruct() : Void
    {
        super.destruct();
        if (_target != null)
        {
            _map.remove(_target);
        }
        pool.dispose(this);
    }
    
    override public function run(pDelta : Float = 1.0) : Void
    {
        _value = (_duration - lifeTime) / _duration;
        if (_ease != null)
        {
            _value = _ease(_value);
        }
        
        if (_target != null)
        {
            for (name in Reflect.fields(_data))
            {
                Reflect.setField(_target, name, (Reflect.field(_data, name) - _startValues[name]) * _value + _startValues[name]);
            }
        }
        if (onUpdate != null)
        {
            onUpdate(_value);
        }
    }
    
    /**
		 * 
		 * @param	pTarget
		 * @param	pDuration in frames
		 * @param	pValues
		 * @return
		 */
    public static function to(pTarget : Dynamic, pDuration : Int, pData : Dynamic, pEase : Function = null, pPriority : Int = -10, pName : String = "Tween") : JamTween
    {
        var tw : JamTween;
        if (pTarget != null && _map[pTarget] != null)
        {
            tw = _map[pTarget];
        }
        else
        {
            tw = cast((pool.create()), JamTween);
        }
        tw.destroyed = false;
        tw.paused = false;
        tw._priority = pPriority;
        tw.name = pName;
        tw._target = pTarget;
        tw._ease = pEase;
        tw.onRun = null;
        tw.onUpdate = (pData.exists("onUpdate")) ? pData.onUpdate : null;
        tw.onDestruct = (pData.exists("onComplete")) ? pData.onComplete : null;
        tw._data = pData;
        tw._duration = tw.lifeTime = pDuration;
        
        tw._value = 0;
        if (tw._target)
        {
            for (name in Reflect.fields(tw._data))
            {
                tw._startValues[name] = Reflect.field(tw._target,name);
            }
        }
        if (tw._target)
        {
            _map[tw._target] = tw;
        }
        tw.init();
        return tw;
    }
}

