package jammer;

import flash.display.Stage;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Context
{
    public static inline var LAYER_BACKGROUND : String = "background";
    public static inline var LAYER_FOREGROUND : String = "foreground";
    public static inline var LAYER_CONTENT : String = "content";
    public static inline var LAYER_PARTICLES : String = "particles";
    public static inline var LAYER_MESSAGES : String = "messages";
    public static inline var LAYER_UI : String = "ui";
    public static inline var LAYER_CURSOR : String = "cursor";
    
    public static var stage : Stage;
    public static var fps : Int;
    public static var game : AbstractGame;
    public static var scale : Float;
    public static var frameId : Int;
    public static var width : Int;
    public static var height : Int;
    
    public function new()
    {
    }
    
    @:meta(Inline())

    public static function secondToFPS(pTime : Float) : Int
    {
        return Std.int(pTime * fps + 0.5);
    }
}

