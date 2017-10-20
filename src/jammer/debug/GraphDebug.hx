package jammer.debug;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class GraphDebug extends Sprite
{
    
    private static var _me : GraphDebug;
    private var _rendering : DisplayObject;
    private var _g : Graphics;
    private var _history : Array<Float>;
    private var _limit : Int;
    private var _height : Int;
    private var _data : Array<Float>;
    private var _cmd : Array<Int>;
    private var _map : Dictionary;
    
    public function new(pLimit : Float, pHeight : Float = 200)
    {
        super();
        _me = this;
        _rendering = new Shape();
        this.addChild(_rendering);
        _g = cast((_rendering), Shape).graphics;
        _history = new Array<Float>();
        _map = new Dictionary();
        _limit = Std.int(pLimit);
        _height = Std.int(pHeight);
        
        _cmd = new Array<Int>();
        _data = new Array<Float>();
        
        this.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
        this.addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
    }
    
    private function _addedToStageHandler(e : Event) : Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
        y = (this.stage.stageHeight - _height) * 0.5;
    }
    
    
    public static function create(pName : String, pColor : Int = 0xFF0000, pScaleX : Float = 10, pScaleY : Float = 10) : Void
    {
        if (_me == null)
        {
            return;
        }
        _me._map[pName] = new GraphData(pName, pColor, pScaleX, pScaleY);
    }
    
    @:meta(Inline())

    public static function addValue(pName : String, pValue : Float) : Void
    {
        if (_me == null)
        {
            return;
        }
        var data : GraphData = _me._map[pName];
        if (data != null)
        {
            data.history.push(pValue);
            if (data.history.length > _me._limit)
            {
                data.history.shift();
            }
        }
    }
    
    private function _enterFrameHandler(pEvent : Event) : Void
    {
        _g.clear();
        var data : GraphData;
        for (name in Reflect.fields(_map))
        {
            data = _map[name];
            _cmd.splice(0, _cmd.length);
            _data.splice(0, _cmd.length);
            var i : Int = 0;
            var c : Int = data.history.length;
            while (i < c)
            {
                _cmd.push((i == 0) ? 1 : 2);
                _data.push(
                        i * data.scaleX
            );
                _data.push(
                        _height * 0.5 + data.history[i] * data.scaleY
            );
                
                i++;
            }
            _g.lineStyle(2, data.color);
            _g.drawPath(_cmd, _data);
        }
    }
}



class GraphData
{
    public var history : Array<Float>;
    public var scaleX : Float;
    public var scaleY : Float;
    public var color : Int;
    public var name : String;
    
    @:allow(com.casusludi.lib.jammer.debug)
    private function new(pName : String, pColor : Int, pScaleX : Float, pScaleY : Float)
    {
        name = pName;
        scaleX = pScaleX;
        scaleY = pScaleY;
        color = pColor;
        history = new Array<Float>();
    }
}