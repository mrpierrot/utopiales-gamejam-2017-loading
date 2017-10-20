package jammer.engines.level;

import haxe.Constraints.Function;
import jammer.engines.display.assets.TileSetAsset;
import jammer.engines.display.types.JamTiles;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

typedef HvDirectionsTypedef = {
    var x : Int;
    var y : Int;
};

typedef AllDirectionsTypedef = {
    var x : Int;
    var y : Int;
};



/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Level
{
    
    public static var HV_DIRECTIONS : Array<HvDirectionsTypedef> = [
        {
            x : 0,
            y : 1
        }, 
        {
            x : 0,
            y : -1
        }, 
        {
            x : 1,
            y : 0
        }, 
        {
            x : -1,
            y : 0
        }
    ];
    
    public static var ALL_DIRECTIONS : Array<AllDirectionsTypedef> = [
        {
            x : 0,
            y : 1
        }, 
        {
            x : 0,
            y : -1
        }, 
        {
            x : 1,
            y : 0
        }, 
        {
            x : -1,
            y : 0
        }, 
        {
            x : 1,
            y : 1
        }, 
        {
            x : -1,
            y : -1
        }, 
        {
            x : 1,
            y : -1
        }, 
        {
            x : -1,
            y : 1
        }
    ];
    
    public var layers : Array<JamTiles>;
    public var layersMap : Map<String,JamTiles>;
    public var cells : Array<Cell>;
    public var markers : Map<String,Dynamic>;
    public var cols : Int;
    public var rows : Int;
    //public var tileSize:int;
    public var tileWidth : Int;
    public var tileHeight : Int;
    public var toStringCellRender : Function;
    
    public function new(pCols : Int, pRows : Int, pTileWidth : Int, pTileHeight : Int, pCellCollideDefault : Bool = false)
    {
        cols = pCols;
        rows = pRows;
        //tileSize = pTileSize;
        tileWidth = pTileWidth;
        tileHeight = pTileHeight;
        layers = new Array<JamTiles>();
        layersMap = new Map<String,JamTiles>();
        cells = new Array<Cell>();
        var cell : Cell;
        var i : Int = 0;
        var c : Int = Std.int(cols * rows);
        while (i < c)
        {
            cell = new Cell(this, i % cols, Std.int(i / cols));
            cell.collide = pCellCollideDefault;
            cells.push(cell);
            i++;
        }
        markers = new Map<String,Dynamic>();
    }
    
    @:final public function createLayer(pName : String, pAssets : TileSetAsset) : JamTiles
    {
        if (!layersMap.exists(pName))
        {
            addLayer(new JamTiles(pAssets, tileWidth, tileHeight, cols, rows), pName);
        }
        return layersMap[pName];
    }
    
    @:final public function addLayer(pLayer : JamTiles, pName : String = null) : Void
    {
        if (pName != null)
        {
            layersMap[pName] = pLayer;
        }
        layers.push(pLayer);
    }
    
    
    
    @:final public function getLayerByName(pName : String) : JamTiles
    {
        return layersMap[pName];
    }
    
    @:final public function getLayerByIndex(pIndex : Int) : JamTiles
    {
        return layers[pIndex];
    }
    
    @:meta(Inline())

    @:final public function getCell(pCx : Int, pCy : Int) : Cell
    {
        if (pCy < 0)
        {
            return null;
        }
        if (pCy >= rows)
        {
            return null;
        }
        if (pCx < 0)
        {
            return null;
        }
        if (pCx >= cols)
        {
            return null;
        }
        return cells[pCy * cols + pCx];
    }
    
    @:meta(Inline())

    @:final public function getCellByXY(pX : Int, pY : Int) : Cell
    {
        pX = Std.int(pX / tileWidth);
        pY = Std.int(pY / tileHeight);
        if (pY < 0)
        {
            return null;
        }
        if (pY >= rows)
        {
            return null;
        }
        if (pX < 0)
        {
            return null;
        }
        if (pX >= cols)
        {
            return null;
        }
        return cells[pY * cols + pX];
    }
    
    public function addMarker(pName : String, pCx : Int, pCy : Int) : Void
    {
        var cell : Cell = getCell(pCx, pCy);
        if (cell != null)
        {
            cell.addMarker(pName);
        }
    }
    
    public function removeMarker(pName : String, pCx : Int, pCy : Int) : Void
    {
        var cell : Cell = getCell(pCx, pCy);
        if (cell != null)
        {
            cell.removeMarker(pName);
        }
    }
    
    @:allow(jammer.engines.level)
    private function _addMarker(pName : String, pCell : Cell) : Void
    {
        if (!markers.exists(pName))
        {
            markers[pName] = new Array<Cell>();
        }
        markers[pName].push(pCell);
    }
    
    
    @:allow(jammer.engines.level)
    private function _removeMarker(pName : String, pCell : Cell) : Void
    {
        if (markers.exists(pName))
        {
            var cells : Array<Cell> = markers[pName];
            var i : Int = Lambda.indexOf(cells, pCell);
            if (i >= 0)
            {
                cells.splice(i, 1);
            }
        }
    }
    
    public function getMarkers(pName : String) : Array<Cell>
    {
        if (markers.exists(pName))
        {
            return markers[pName];
        }
        return null;
    }
    
    
    
    @:meta(Inline())

    @:final public function hasCollision(pCx : Int, pCy : Int) : Bool
    {
        if (pCy < 0)
        {
            return true;
        }
        if (pCy >= rows)
        {
            return true;
        }
        if (pCx < 0)
        {
            return true;
        }
        if (pCx >= cols)
        {
            return true;
        }
        var cell : Cell = cells[pCy * cols + pCx];
        if (cell == null)
        {
            return true;
        }
        return cell.collide;
    }
    
    public function toString() : String
    {
        var ret : String = "\n";
        var cell : Cell;
        var i : Int = 0;
        var c : Int = cells.length;
        while (i < c)
        {
            cell = cells[i];
            //ret += cell.collide?"[X]":"["+(toStringCellRender==null?" ":toStringCellRender(cell))+"]";
			ret += (toStringCellRender != null)? toStringCellRender(cell):(cell.collide?"[X]":"[ ]");
            if (i % cols == cols - 1)
            {
                ret += "\n";
            }
            i++;
        }
        
        return ret;
    }
    
    public function showBreadthFirstPaths() : String
    {
        var ret : String = "";
        var cell : Cell;
        var next : Cell;
        var i : Int = 0;
        var c : Int = cells.length;
        while (i < c)
        {
            cell = cells[i];
            if (cell.collide)
            {
                ret += "[ ]";
            }
            else
            {
                next = cell.next;
                if (next != null)
                {
                    if (next.cy - cell.cy > 0)
                    {
                        ret += "[v]";
                    }
                    else
                    {
                        if (next.cy - cell.cy < 0)
                        {
                            ret += "[^]";
                        }
                        else
                        {
                            if (next.cx - cell.cx > 0)
                            {
                                ret += "[>]";
                            }
                            else
                            {
                                if (next.cx - cell.cx < 0)
                                {
                                    ret += "[<]";
                                }
                            }
                        }
                    }
                }
                else
                {
                    ret += "[ ]";
                }
            }
            if (i % cols == cols - 1)
            {
                ret += "\n";
            }
            i++;
        }
        
        return ret;
    }
    
    public function getBounds() : Rectangle
    {
        return new Rectangle(0, 0, cols * tileWidth, rows * tileHeight);
    }
}

