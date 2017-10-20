package jammer.engines.display.assets;

import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class TileSetAsset extends Asset
{
    
    public var placements : Map<String,Array<Rectangle>>;
    public var width : Int;
    public var height : Int;
    
    
    public function new(pName : String, pData : BitmapData, pPlacements : Map<String,Array<Rectangle>>)
    {
        super(pName, pData);
        placements = pPlacements;
    }
    
    public function getRandomTile(pName : String) : Rectangle
    {
        if (placements.exists(pName))
        {
            var list : Array<Rectangle> = placements[pName];
            return list[Std.int(Math.random() * list.length)];
        }
        return null;
    }
    
    public function getTile(pName : String, index : Int = 0) : Rectangle
    {
        if (placements.exists(pName))
        {
            var list : Array<Rectangle> = placements[pName];
            if (index < list.length)
            {
                return list[index];
            }
        }
        return null;
    }
    
    public function getAllTilesByName(pName : String) : Array<Rectangle>
    {
        if (placements.exists(pName))
        {
            return placements[pName];
        }
        return null;
    }
}

