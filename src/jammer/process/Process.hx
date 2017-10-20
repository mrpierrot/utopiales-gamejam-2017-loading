package jammer.process;

import haxe.Constraints.Function;
import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Process
{
    public static var FPS : Int;
    public static var pausedAll : Bool = false;
    public static var ALL : Array<Process> = new Array<Process>();
    
    private static var _startTime : Float;
    private static var _lastTime : Float;
    private static var _initialized : Bool;
    
    public var paused : Bool;
    public var destroyed : Bool;
    public var onRun : Function;
    public var onDestruct : Function;
    public var lifeTime : Int;
    public var name : String;
    private var _priority : Int;
    
    public function new(pPriority : Int = 0, pName : String = null, pAutoInit : Bool = true)
    {
        paused = destroyed = false;
        lifeTime = -1;
        _priority = pPriority;
        name = pName;
        if (pAutoInit)
        {
            init();
        }
    }
    
    public function init() : Void
    {
        var i : Int = ALL.length - 1;
        while (i >= 0)
        {
            if (ALL[i]._priority <= _priority)
            {
				ALL.insert(i, this);
                break;
            }
            i--;
        }
        if (i < 0)
        {
            ALL.push(this);
        }
    }
    
    public function run(pDelta : Float = 1.0) : Void
    {
        if (onRun != null)
        {
            onRun(pDelta);
        }
    }
    
    public function destruct() : Void
    {
        if (onDestruct != null)
        {
            onDestruct();
        }
    }
    
    public static function initialise(pStage : Stage) : Void
    {
        if (!_initialized)
        {
            _initialized = true;
            _lastTime = Math.round(haxe.Timer.stamp() * 1000);
            Process.FPS = Std.int(pStage.frameRate);
            pStage.addEventListener(Event.ENTER_FRAME, _timeHandler);
        }
    }
    
    
    private static function _timeHandler(e : Event) : Void
    {
        var newTime : Float = Math.round(haxe.Timer.stamp() * 1000);
        var deltaTime : Float = Math.round(haxe.Timer.stamp() * 1000) - _lastTime;
        if (!pausedAll)
        {
            var rate : Float = FPS * deltaTime * 0.001;
            var i : Int;
            var c : Int = ALL.length;
            var process : Process;
			i = 0;
			while (i < c)
            {
                process = ALL[i];
                if (!process.destroyed)
                {
                    if (!process.paused)
                    {
						process.run(rate);
						if (process.lifeTime >= 0)
						{
							process.lifeTime--;
							if (process.lifeTime <= 0)
							{
								process.destroyed = true;
							}
						}
					}
                }
                if (process.destroyed)
                {
                    process.destruct();
                    ALL.splice(i, 1);
                    c--;
                    i--;
                }
				i++;
            }
        }
        _lastTime = newTime;
    }
    
    public function toString() : String
    {
        return "[Process name=" + name + " priority=" + _priority + " FPS=" + FPS + " ]";
    }
}

