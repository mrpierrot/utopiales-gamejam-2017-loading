package jammer.engines.level.gen.dungeon;

import jammer.collections.Enumeration;
import jammer.engines.level.Level;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DungeonLevel extends Level
{
    
    public var rooms : Enumeration<Room>;
    public var corridors : Enumeration<Corridor>;
    public var startRoom : Room;
    public var endRoom : Room;
    public var properties : Dynamic;
    
    public function new(pCols : Int, pRows : Int, pTileWidth : Int, pTileHeight : Int)
    {
        super(pCols, pRows, pTileWidth, pTileHeight, true);
        rooms = new Enumeration<Room>();
        corridors = new Enumeration<Corridor>();
        properties = { };
    }
}

