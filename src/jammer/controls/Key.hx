package jammer.controls;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Key
{
    
    public static inline var A : Int = 65;
    public static inline var ALTERNATE : Int = 18;
    public static inline var B : Int = 66;
    public static inline var BACKQUOTE : Int = 192;
    public static inline var BACKSLASH : Int = 220;
    public static inline var BACKSPACE : Int = 8;
    public static inline var C : Int = 67;
    public static inline var CAPS_LOCK : Int = 20;
    public static inline var COMMA : Int = 188;
    public static inline var COMMAND : Int = 15;
    public static inline var CONTROL : Int = 17;
    public static inline var D : Int = 68;
    public static inline var DELETE : Int = 46;
    public static inline var DOWN : Int = 40;
    public static inline var E : Int = 69;
    public static inline var END : Int = 35;
    public static inline var ENTER : Int = 13;
    public static inline var EQUAL : Int = 187;
    public static inline var ESCAPE : Int = 27;
    public static inline var F : Int = 70;
    public static inline var F1 : Int = 112;
    public static inline var F10 : Int = 121;
    public static inline var F11 : Int = 122;
    public static inline var F12 : Int = 123;
    public static inline var F13 : Int = 124;
    public static inline var F14 : Int = 125;
    public static inline var F15 : Int = 126;
    public static inline var F2 : Int = 113;
    public static inline var F3 : Int = 114;
    public static inline var F4 : Int = 115;
    public static inline var F5 : Int = 116;
    public static inline var F6 : Int = 117;
    public static inline var F7 : Int = 118;
    public static inline var F8 : Int = 119;
    public static inline var F9 : Int = 120;
    public static inline var G : Int = 71;
    public static inline var H : Int = 72;
    public static inline var HOME : Int = 36;
    public static inline var I : Int = 73;
    public static inline var INSERT : Int = 45;
    public static inline var J : Int = 74;
    public static inline var K : Int = 75;
    public static inline var L : Int = 76;
    public static inline var LEFT : Int = 37;
    public static inline var LEFTBRACKET : Int = 219;
    public static inline var M : Int = 77;
    public static inline var MINUS : Int = 189;
    public static inline var N : Int = 78;
    public static inline var NUMBER_0 : Int = 48;
    public static inline var NUMBER_1 : Int = 49;
    public static inline var NUMBER_2 : Int = 50;
    public static inline var NUMBER_3 : Int = 51;
    public static inline var NUMBER_4 : Int = 52;
    public static inline var NUMBER_5 : Int = 53;
    public static inline var NUMBER_6 : Int = 54;
    public static inline var NUMBER_7 : Int = 55;
    public static inline var NUMBER_8 : Int = 56;
    public static inline var NUMBER_9 : Int = 57;
    public static inline var NUMPAD : Int = 21;
    public static inline var NUMPAD_0 : Int = 96;
    public static inline var NUMPAD_1 : Int = 97;
    public static inline var NUMPAD_2 : Int = 98;
    public static inline var NUMPAD_3 : Int = 99;
    public static inline var NUMPAD_4 : Int = 100;
    public static inline var NUMPAD_5 : Int = 101;
    public static inline var NUMPAD_6 : Int = 102;
    public static inline var NUMPAD_7 : Int = 103;
    public static inline var NUMPAD_8 : Int = 104;
    public static inline var NUMPAD_9 : Int = 105;
    public static inline var NUMPAD_ADD : Int = 107;
    public static inline var NUMPAD_DECIMAL : Int = 110;
    public static inline var NUMPAD_DIVIDE : Int = 111;
    public static inline var NUMPAD_ENTER : Int = 108;
    public static inline var NUMPAD_MULTIPLY : Int = 106;
    public static inline var NUMPAD_SUBTRACT : Int = 109;
    public static inline var O : Int = 79;
    public static inline var P : Int = 80;
    public static inline var PAGE_DOWN : Int = 34;
    public static inline var PAGE_UP : Int = 33;
    public static inline var PERIOD : Int = 190;
    public static inline var Q : Int = 81;
    public static inline var QUOTE : Int = 222;
    public static inline var R : Int = 82;
    public static inline var RIGHT : Int = 39;
    public static inline var RIGHTBRACKET : Int = 221;
    public static inline var S : Int = 83;
    public static inline var SEMICOLON : Int = 186;
    public static inline var SHIFT : Int = 16;
    public static inline var SLASH : Int = 191;
    public static inline var SPACE : Int = 32;
    public static inline var T : Int = 84;
    public static inline var TAB : Int = 9;
    public static inline var U : Int = 85;
    public static inline var UP : Int = 38;
    public static inline var V : Int = 86;
    public static inline var W : Int = 87;
    public static inline var X : Int = 88;
    public static inline var Y : Int = 89;
    public static inline var Z : Int = 90;
    
    
    private static var _downKeys : Map<Int,Bool>;
    private static var _upKeys : Map<Int,Bool>;
    private static var _toggledKeys : Map<Int,Bool>;
    private static var _initialized : Bool;
    
    public static function init(pStage : Stage) : Void
    {
        if (!_initialized)
        {
            _initialized = true;
            _downKeys = new Map<Int,Bool>();
            _upKeys = new Map<Int,Bool>();
            _toggledKeys = new Map<Int,Bool>();
            pStage.addEventListener(KeyboardEvent.KEY_UP, _keyUpListener);
            pStage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownListener);
        }
    }
    
    @:meta(Inline())

    public static function isDown(pKey : Int) : Bool
    {
        return _downKeys.exists(pKey);
    }
    
    @:meta(Inline())

    public static function isToggled(pKey : Int) : Bool
    {
        return _toggledKeys.exists(pKey);
    }
    
    private static function _keyDownListener(pEvent : KeyboardEvent) : Void
    {
        _downKeys[pEvent.keyCode] = true;
    }
    
    private static function _keyUpListener(pEvent : KeyboardEvent) : Void
    {
        _upKeys[pEvent.keyCode] = true;
    }
    
    @:meta(Inline())

    public static function update() : Void
    {
        if (!_initialized)
        {
            return;
        }
        var k : Int;
        for (k in _toggledKeys.keys())
        {
            _toggledKeys.remove(k);
        }
        
        for (k in _upKeys.keys())
        {
            _downKeys.remove(k);
			_upKeys.remove(k);
            _toggledKeys[k] = true;
        }
    }

    public function new()
    {
    }
}

