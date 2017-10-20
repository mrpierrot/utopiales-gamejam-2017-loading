package jammer.engines.display.camera;

import jammer.engines.display.types.JamDisplayObject;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Camera
{
    
    public static inline var SMOOTH_MODE : String = "";
    
    public var x : Int;
    public var y : Int;
    public var dx : Float;
    public var dy : Float;
    public var centerX : Int;
    public var centerY : Int;
    public var mode : String;
    public var movementStrategy : ICameraMovementStrategy;
    public var world : Rectangle;
    private var _target : JamDisplayObject;
    private var _xx : Int;
    private var _yy : Int;
    public var xx : Int;
    public var yy : Int;
    private var _reseted : Bool;
    public var width : Int;
    public var height : Int;
    
    
    public function new(pWidth : Int, pHeight : Int)
    {
        setDimensions(pWidth, pHeight);
        x = y = 0;
        dx = dy = 0;
        xx = yy = 0;
    }
    
    public function setDimensions(pWidth : Int, pHeight : Int) : Void
    {
        width = pWidth;
        height = pHeight;
        centerX = Std.int(width * 0.5);
        centerY = Std.int(height * 0.5);
    }
    
    public function lockOn(pTarget : JamDisplayObject) : Void
    {
        if (_target == null)
        {
            _target = pTarget;
            if (_target.frameData != null)
            {
                x = _xx = Std.int(-_target.x + centerX - _target.frameData.source.width * 0.5);
                y = _yy = Std.int(-_target.y + centerY - _target.frameData.source.height * 0.5);
            }
            else
            {
                x = _xx = Std.int(-_target.x + centerX);
                y = _yy = Std.int(-_target.y + centerY);
            }
            _updateWorld(true);
        }
        else
        {
            _target = pTarget;
        }
    }
    
    public function reset() : Void
    {
        dx = dy = 0;
        _reseted = true;
    }
    
    @:meta(Inline())

    @:final private function _updateWorld(pForce : Bool) : Void
    {
        if (world != null)
        {
            var ww : Int = (Std.int(world.width) - width);
            var wh : Int = (Std.int(world.height) - height);
            if (ww > 0)
            {
                if (_xx > 0)
                {
                    _xx = 0;
                }
                if (_xx < -ww)
                {
                    _xx = -ww;
                }
            }
            else
            {
                _xx = Std.int(-ww * 0.5);
            }
            if (wh > 0)
            {
                if (_yy > 0)
                {
                    _yy = 0;
                }
                if (_yy < -wh)
                {
                    _yy = -wh;
                }
            }
            else
            {
                _yy = Std.int(-wh * 0.5);
            }
            if (pForce)
            {
                x = _xx;
                y = _yy;
            }
        }
    }
    
    
    
    public function update() : Void
    {
        if (_target != null)
        {
            if (_target.frameData != null)
            {
                _xx = Std.int(-_target.x + centerX - _target.frameData.source.width * 0.5);
                _yy = Std.int(-_target.y + centerY - _target.frameData.source.height * 0.5);
            }
            else
            {
                _xx = Std.int(-_target.x + centerX);
                _yy = Std.int(-_target.y + centerY);
            }
        }
        else
        {
            _xx = Std.int(-xx + centerX);
            _yy = Std.int(-yy + centerY);
        }
        
        _updateWorld(false);
        
        if (movementStrategy != null && !_reseted)
        {
            movementStrategy.update(this, _xx, _yy);
        }
        else
        {
            x = _xx;
            y = _yy;
            _reseted = false;
        }
    }
}

