package jammer.engines.level.gen.dungeon;

import jammer.collections.Enumeration;
import jammer.engines.level.Cell;
import jammer.engines.level.ILevelStructure;
import jammer.engines.level.Level;
import flash.geom.Point;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Room implements ILevelStructure
{
    public var links(get, never) : Enumeration<ILevelStructure>;
    public var markers(get, never) : Enumeration<String>;

    
    public var cx : Int;
    public var cy : Int;
    public var width : Int;
    public var height : Int;
    public var center : Cell;
    public var id : Int;
    public var properties : Dynamic;
    public var floorTileName : String;
    private var _markers : Enumeration<String>;
    private var _links : Enumeration<ILevelStructure>;
    
    public function new(pId : Int, pCx : Int = 0, pCy : Int = 0, pWidth : Int = 0, pHeight : Int = 0, pFloorTileName : String = "tile:floor")
    {
        id = pId;
        floorTileName = pFloorTileName;
        init(pCx, pCy, pWidth, pHeight);
        properties = { };
        _markers = new Enumeration<String>();
        _links = new Enumeration<ILevelStructure>();
    }
    
    public function init(pCx : Int, pCy : Int, pWidth : Int, pHeight : Int) : Void
    {
        cx = pCx;
        cy = pCy;
        width = pWidth;
        height = pHeight;
    }
    
    
    public function collide(pRoom : Room) : Bool
    {
        if (this.cx < pRoom.cx + pRoom.width && this.cx + this.width > pRoom.cx && this.cy < pRoom.cy + pRoom.height && this.cy + this.height > pRoom.cy)
        {
            return true;
        }
        return false;
    }
    
    
    @:meta(Inline())

    @:final public function levelCollide(pLevel : Level) : Bool
    {
        var cell : Cell;
        var x : Int = this.cx;
        var xmax : Int = Std.int(this.cx + this.width);
        while (x < xmax)
        {
            var y : Int = this.cy;
            var ymax : Int = Std.int(this.cy + this.height);
            while (y < ymax)
            {
                cell = pLevel.getCell(x, y);
                //if (x == this.cx || x == xmax - 1 || y == this.cy || y == ymax - 1) continue;
                if (cell.structure != null)
                {
                    return true;
                }
                y++;
            }
            x++;
        }
        return false;
    }
    
    
    public function updateLevel(pLevel : Level) : Void
    {
        var cell : Cell;
        center = pLevel.getCell(this.cx + Std.int(this.width * 0.5), this.cy + Std.int(this.height * 0.5));
        pLevel.getCell(this.cx, this.cy).addMarker("corner");
        pLevel.getCell(this.cx + this.width - 1, this.cy).addMarker("corner");
        pLevel.getCell(this.cx + this.width - 1, this.cy + this.height - 1).addMarker("corner");
        pLevel.getCell(this.cx, this.cy + this.height - 1).addMarker("corner");
        var x : Int = this.cx;
        var xmax : Int = Std.int(this.cx + this.width);
        while (x < xmax)
        {
            var y : Int = this.cy;
            var ymax : Int = Std.int(this.cy + this.height);
            while (y < ymax)
            {
                cell = pLevel.getCell(x, y);
                
                cell.collide = x == this.cx || x == xmax - 1 || y == this.cy || y == ymax - 1;
                if (cell.collide)
                {
                    cell.addMarker("wall");
                }
                if (!cell.collide)
                {
                    cell.structure = this;
                    cell.addMarker("floor");
                    cell.addMarker(floorTileName);
                }
                y++;
            }
            x++;
        }
    }
    
    public function toString() : String
    {
        return "[Room id=" + id + " cx=" + cx + " cy=" + cy + " width=" + width + " height=" + height + "]";
    }
    
    private function get_links() : Enumeration<ILevelStructure>
    {
        return _links;
    }
    
    private function get_markers() : Enumeration<String>
    {
        return _markers;
    }
}

