package jammer.engines.display.assets.parsers;

import jammer.engines.display.assets.AnimationState;
import flash.geom.Rectangle;



typedef AnimationStateDef = {
	@:optional var framerate:Int;
	@:optional var cues:Map<Int,String>;
	var frames:Dynamic;
	var width:Int;
	var height:Int;
};

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DumbParser
{
    
    public function new()
    {
    }
    
    private var _SHORT_FORMAT : EReg = new EReg('([0-9]+)(:([0-9]+))+', "g");
    public static function parseAnimations(pStates : Dynamic, pWidth : Int, pHeight : Int, pFramerate : Int) : Map<String,AnimationState>
    {
        var ret : Map<String,AnimationState> = new Map<String,AnimationState>();
        var data : AnimationStateDef;
        var frames : Array<Rectangle>;
        var framesIndexes : Array<Int>;
        var width : Int;
        var height : Int;
        var result : Array<Dynamic>;
        var start : Int;
        var end : Int;
        var i : Int;
        var c : Int;
        var index : Int;
        var cols : Int;
        for (name in Reflect.fields(pStates))
        {
            data = Reflect.field(pStates, name);
            width = data.width;
            height = data.height;
            cols = Std.int(pWidth / width);
            framesIndexes = null;
            
            if (Std.is(data.frames, String))
            {
                result = Std.string(data.frames).split(":");
                
                if (result.length >= 2)
                {
                    framesIndexes = [];
					c = result.length - 1;
                    for (i in 0...c)
                    {
                        start = result[i];
                        end = result[i + 1];
                        if (i > 0)
                        {
                            if (end > start)
                            {
                                start++;
                            }
                            else
                            {
                                if (end < start)
                                {
                                    start--;
                                }
                            }
                        }
                        
                        if (start <= end)
                        {
                            while (start <= end)
                            {
                                framesIndexes.push(start++);
                            }
                        }
                        else
                        {
                            while (start >= end)
                            {
                                framesIndexes.push(start--);
                            }
                        }
                    }
                }
                else
                {
                    if (result.length == 1)
                    {
                        framesIndexes = [result[0]];
                    }
                }
            }
            else
            {
                if (Std.is(data.frames, Array))
                {
                    framesIndexes = data.frames;
                }
                else
                {
                    if (Std.is(data.frames, Dynamic) && data.frames.x && data.frames.y)
                    {
                        framesIndexes = parse2pFormat(Std.string(data.frames.x), Std.string(data.frames.y), cols);
                    }
                }
            }
            if (framesIndexes != null)
            {
                frames = new Array<Rectangle>();
				c = framesIndexes.length;
                for (i in 0...c)
                {
                    index = framesIndexes[i];
                    frames.push(new Rectangle(width * (index % cols), width * Std.int(index / cols), width, height));
                }
				ret.set(name, new AnimationState(name, frames, Reflect.hasField(data,"framerate") ? data.framerate : pFramerate,Reflect.hasField(data,"cues")?data.cues:null));
            }
        }
        
        return ret;
    }
    
    public static function parseTileSet(pRet : Map<String,Array<Rectangle>>, pPlacements : Dynamic, pTileWidth : Int, pTileHeight : Int, pStartY : Int, pWidth : Int, pHeight : Int) : Void
    {
        var ret : Map<String,Array<Rectangle>> = pRet;
        var data : Dynamic;
        var tiles : Array<Rectangle>;
        var tilesIndexes : Array<Dynamic>;
        var width : Int = pTileWidth;
        var height : Int = pTileHeight;
        var result : Array<Dynamic>;
        var start : Int;
        var end : Int;
        var i : Int;
        var c : Int;
        var index : Int;
        var cols : Int = Std.int(pWidth / width);
        for (name in Reflect.fields(pPlacements))
        {
            data = Reflect.field(pPlacements, name);
            tilesIndexes = null;
            if (Std.is(data, String))
            {
                result = Std.string(data).split(":");
                if (result.length >= 2)
                {
                    tilesIndexes = [];
					c =  result.length - 1;
                    for (i in 0...c)
                    {
                        start = result[i];
                        end = result[i + 1];
                        if (i > 0)
                        {
                            if (end > start)
                            {
                                start++;
                            }
                            else
                            {
                                if (end < start)
                                {
                                    start--;
                                }
                            }
                        }
                        
                        if (start <= end)
                        {
                            while (start <= end)
                            {
                                tilesIndexes.push(start++);
                            }
                        }
                        else
                        {
                            while (start >= end)
                            {
                                tilesIndexes.push(start--);
                            }
                        }
                    }
                }
                else
                {
                    if (result.length == 1)
                    {
                        tilesIndexes = [result[0]];
                    }
                }
            }
            else
            {
                if (Std.is(data.placements, Array))
                {
                    tilesIndexes = data.frames;
                }
                else
                {
                    if (Std.is(data, Dynamic) && data.x && data.y)
                    {
                        tilesIndexes = parse2pFormat(Std.string(data.x), Std.string(data.y), cols);
                    }
                }
            }
            
            if (tilesIndexes != null)
            {
                tiles = new Array<Rectangle>();
				c = tilesIndexes.length;
                for (i in 0...c)
                {
                    index = tilesIndexes[i];
                    tiles.push(new Rectangle(width * (index % cols), pStartY + height * Std.int(index / cols), width, height));
                }
				ret.set(name, tiles);
            }
        }
    }
    
    @:meta(Inline())

    public static function parse2pFormat(pX : String, pY : String, pCols : Int) : Array<Int>
    {
        var xConf : Array<Dynamic> = pX.split(":");
        var yConf : Array<Dynamic> = pY.split(":");
        if (xConf.length == 0)
        {
            return null;
        }
        if (yConf.length == 0)
        {
            return null;
        }
        var ret : Array<Int> = [];
        var minX : Int = xConf[0];
        var maxX : Int = xConf[xConf.length - 1];
        var minY : Int = yConf[0];
        var maxY : Int = yConf[yConf.length - 1];
        
        
        for (y in minY...maxY + 1)
        {
            for (x in minX...maxX + 1)
            {
                ret.push((x - 1) + (y - 1) * pCols);
            }
        }
        return ret;
    }
}

