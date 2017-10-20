package jammer.utils;

import haxe.Constraints.Function;
import jammer.engines.display.assets.TileSetAsset;
import jammer.engines.level.Level;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author ...
	 */
class TilePatternUtils
{
    
    public function new()
    {
    }
    
    
    @:meta(Inline())

    public static function randomPattern(pAssets : TileSetAsset, pName : String, pCx : Int, pCy : Int) : Rectangle
    {
        return pAssets.getRandomTile(pName);
    }
    
    public static function createWeightRandomPattern(pWeight : Array<Float>) : Function
    {
        return function(pAssets : TileSetAsset, pName : String, pCx : Int, pCy : Int) : Rectangle
        {
            var tiles : Array<Rectangle> = pAssets.getAllTilesByName(pName);
            var tileCount : Int = tiles.length;
            var weightCount : Int = pWeight.length;
            var finalCount : Int = weightCount;
            if (tileCount < weightCount)
            {
                finalCount = tileCount;
            }
            var total : Float = 0;
            for (i in 0...finalCount)
            {
                total += pWeight[i];
            }
            
            /*var index:int = -1;
				var t:Number = 0;
				var rnd:Number = Math.random() * total;
				do{
					index++;
					if (pWeight[index] < 0) continue;
					t += pWeight[index];
					
				}while (rnd > t);*/
            
            var rnd : Float = Math.random() * total;
            
            
            
            for (index in 0...tileCount)
            {
                if (rnd < pWeight[index])
                {
                    return tiles[index];
                }
                rnd -= pWeight[index];
            }
            
            
            return tiles[0];
        };
    }
    
    public static function createOrientedPattern(pLevel : Level) : Function
    {
        return function(pAssets : TileSetAsset, pName : String, pCx : Int, pCy : Int) : Rectangle
        {
            return null;
        };
    }
    
    
    @:meta(Inline())

    public static function alternatePattern(pAssets : TileSetAsset, pName : String, pCx : Int, pCy : Int) : Rectangle
    {
        var tiles : Array<Rectangle> = pAssets.getAllTilesByName(pName);
        var count : Int = tiles.length;
        return tiles[(pCy % 2 + pCx % count) % count];
    }
}

