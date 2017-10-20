package jammer.controls;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Mouse
{
    
    
    
    
    private static var _down : Bool;
    private static var _up : Bool;
    private static var _clicked : Bool;
    private static var _initialized : Bool;
    
    public static var localX : Int;
    public static var localY : Int;
    
    public static function init(pStage : Stage) : Void
    {
        if (!_initialized)
        {
            _initialized = true;
            _down = false;
            _up = false;
            _clicked = false;
            pStage.addEventListener(MouseEvent.MOUSE_UP, _mouseUpListener);
            pStage.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownListener);
        }
    }
    
    


    public inline static function isDown() : Bool
    {
        return _down;
    }
    


    public inline static function isClicked() : Bool
    {
        return _clicked;
    }
    
    
    
    private static function _mouseDownListener(pEvent : MouseEvent) : Void
    {
        _down = true;
    }
    
    private static function _mouseUpListener(pEvent : MouseEvent) : Void
    {
        _up = true;
    }
    
    public static function update() : Void
    {
        if (!_initialized)
        {
            return;
        }
        _clicked = false;
        if (_up)
        {
            _down = false;
            _up = false;
            _clicked = true;
        }
    }

    public function new()
    {
    }
}

