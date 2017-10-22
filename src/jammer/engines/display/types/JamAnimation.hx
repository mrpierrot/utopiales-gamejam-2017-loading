package jammer.engines.display.types;

import haxe.Constraints.Function;
import jammer.engines.display.assets.AnimationAsset;
import jammer.engines.display.assets.AnimationState;
import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import flash.display.IBitmapDrawable;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamAnimation extends JamDisplayObject
{
    public var state(get, set) : String;

    
    private var _asset : AnimationAsset;
    public var _currentStateName : String;
    public var _currentState : AnimationState;
    public var _currentStateSize : Int;
    public var _currentFrameIndex : Int;
    public var _lastFrameIndex : Int;
    public var _currentFrame : Rectangle;
    private var _globalFramerate : Int;
    private var _globalToLocalFramerate : Float;
    private var _playing : Bool;
    private var _rawFrameIndex : Int;
    public var _startFrameIndex : Int;
    private var _conditions : Array<Condition>;
    
    public var eventsEnabled : Bool;
    public var loop : Bool;
    public var onPreRender : Function;
    public var onRender : Function;
    public var onStateChange : Function;
    public var onStateComplete : Function;
    public var onCue : Function;
    
    public function new(pAnimationAsset : AnimationAsset, pInitState : String = null, pLoop : Bool = true, pEventsEnabled : Bool = false)
    {
        _asset = pAnimationAsset;
        if (pInitState == null)
        {
            if (_asset.initStateName != null)
            {
                _currentStateName = _asset.initStateName;
            }
            else
            {
                for (name in pAnimationAsset.states.keys())
                {
                    _currentStateName = name;
                    break;
                }
            }
        }
        _currentState = pAnimationAsset.states[_currentStateName];
        if (_currentState != null)
        {
            _currentStateSize = _currentState.frames.length;
        }
        
        super(new FrameData(_asset.data));
        _currentFrameIndex = 0;
        _rawFrameIndex =
                _startFrameIndex = -1;
        _playing = true;
        eventsEnabled = pEventsEnabled;
        _conditions = new Array<Condition>();
        loop = pLoop;
        getFrameData(0);
        centerX = Std.int(frameData.source.width * 0.5);
        centerY = Std.int(frameData.source.height * 0.5);
    }
    
    override public function clone(pFull : Bool = false) : JamDisplayObject
    {
        return new JamAnimation((pFull) ? cast((_asset.clone(true)), AnimationAsset) : _asset, _currentStateName, loop, eventsEnabled);
    }
    
    
    public function play(pState : String = null) : Void
    {
        _playing = true;
        _startFrameIndex = -1;
        this.state = pState;
    }
    
    public function stop() : Void
    {
        _playing = false;
    }
    
	private inline function set_state(pState : String) : String
    {
        if (pState == null || _currentStateName == pState)
        {
            return pState;
        }
        _currentStateName = pState;
        _currentState = _asset.states[_currentStateName];
        if (_currentState != null)
        {
            _currentStateSize = _currentState.frames.length;
            if (_currentState != null && _currentState.framerate > 0)
            {
                _globalToLocalFramerate = _currentState.framerate / _globalFramerate;
            }
            else
            {
                _globalToLocalFramerate = 1;
            }
        }
        else
        {
            _currentStateSize = 0;
        }
        _startFrameIndex = -1;
		_lastFrameIndex = -1;
		
		if (onStateChange != null)
		{
			onStateChange(_currentState);
		}
        return pState;
    }
    
    public function registerStateCondition(pStateName : String, pCallCondition : Function) : Void
    {
        _conditions.push(new Condition(pStateName, pCallCondition));
    }
    
    public function registerStateConditionAt(pIndex : Int, pStateName : String, pCallCondition : Function) : Void
    {
		_conditions.insert(pIndex, new Condition(pStateName, pCallCondition));
    }
    
    
    override inline public function getFrameData(pFrame : Int) : FrameData
    {
        if (_currentState == null || _currentStateSize == 0)
        {
            return null;
        }
        if (_playing)
        {
            var i : Int = 0;
            var c : Int = _conditions.length;
            while (i < c)
            {
                var cond : Condition = _conditions[i];
                if (cond.action())
                {
                    state = cond.state;
                    break;
                }
                i++;
            }
			
			 if (onPreRender != null)
            {
                onPreRender(pFrame);
            }
		
            _rawFrameIndex = pFrame;
            if (_startFrameIndex < 0)
            {
                _startFrameIndex = _rawFrameIndex;
            }
            if (_currentState != null)
            {
                _currentFrameIndex = Std.int(((_rawFrameIndex - _startFrameIndex) * _globalToLocalFramerate) % _currentStateSize);
              /*  trace("_startFrameIndex", _startFrameIndex);
                trace("_rawFrameIndex", _rawFrameIndex);
                trace("_currentStateSize", _currentStateSize);
                trace("_currentFrameIndex", _currentFrameIndex);*/
				_currentFrame = _currentState.frames[_currentFrameIndex];
                frameData.source = _currentFrame;
                frameData.destination.x = x;
                frameData.destination.y = y;
                if (!loop && _currentFrameIndex == _currentStateSize - 1)
                {
                    _playing = false;
                }
				//if (onStateComplete != null && _currentFrameIndex == _currentStateSize - 1)
				if (onStateComplete != null && _lastFrameIndex == _currentStateSize - 1 && _currentFrameIndex == 0)
				{
					onStateComplete(_currentState);
				}
				if (onCue != null && _currentState.cues != null && _lastFrameIndex != _currentFrameIndex && _currentState.cues.exists(_currentFrameIndex)){
					onCue(_currentState.cues[_currentFrameIndex]);
				}
                if (eventsEnabled && _currentFrameIndex == _currentStateSize - 1)
                {
                    
					this.dispatchEvent(new Event(Event.COMPLETE));
					
                }
            }
            if (onRender != null)
            {
                onRender();
            }
			_lastFrameIndex = _currentFrameIndex;
        }
		
        return frameData;
    }
    
    
    override private function set_globalFramerate(value : Int) : Int
    {
        _globalFramerate = value;
        if (_currentState != null && _currentState.framerate > 0)
        {
            _globalToLocalFramerate = _currentState.framerate / _globalFramerate;
        }
        else
        {
            _globalToLocalFramerate = 1;
        }
        return value;
    }
    
    @:final private function get_state() : String
    {
        return _currentStateName;
    }
    
    
    override public function toString() : String
    {
        return "[JamAnimation name=" + _asset.name + "]";
    }
}





class Condition
{
    public var state : String;
    public var action : Function;
    
    @:allow(jammer.engines.display.types)
    private function new(pState : String, pAction : Function)
    {
        state = pState;
        action = pAction;
    }
}

