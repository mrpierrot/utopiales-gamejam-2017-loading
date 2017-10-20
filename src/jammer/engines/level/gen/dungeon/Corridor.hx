package jammer.engines.level.gen.dungeon;

import jammer.collections.Enumeration;
import jammer.engines.level.Cell;
import jammer.engines.level.ILevelStructure;
import jammer.engines.level.Level;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Corridor implements ILevelStructure
{
    public var markers(get, never) : Enumeration<String>;
    public var links(get, never) : Enumeration<ILevelStructure>;

    
    public var cells : Array<Cell>;
    public var floorTileName : String;
    public var properties : Dynamic;
    private var _links : Enumeration<ILevelStructure>;
    private var _markers : Enumeration<String>;
    
    public function new(pFloorTileName : String = "tile:floor")
    {
        floorTileName = pFloorTileName;
        cells = new Array<Cell>();
        _links = new Enumeration<ILevelStructure>();
        _markers = new Enumeration<String>();
        properties = { };
    }
    
    public function addCell(pCell : Cell) : Void
    {
        cells.push(pCell);
    }
    
    public function updateLevel(pLevel : Level) : Void
    {
        var cell : Cell;
        var neightbor : Cell;
        var dir : Dynamic;
        
        for (cell in cells)
        {
            var isWall : Bool = cell.haveMarker("wall");
            var noDoorsNexts : Bool = true;
            for (dir/* AS3HX WARNING could not determine type for var: dir exp: EField(EIdent(Level),HV_DIRECTIONS) type: null */ in Level.HV_DIRECTIONS)
            {
                neightbor = pLevel.getCell(cell.cx + dir.x, cell.cy + dir.y);
                if (neightbor.haveMarker("door"))
                {
                    noDoorsNexts = false;
                }
            }
            if (cell.collide && noDoorsNexts && isWall)
            {
                cell.addMarker("door");
            }
            cell.collide = false;
            //cell.properties.struct = this;
            cell.structure = this;
            cell.addMarker("floor");
            cell.addMarker(floorTileName);
        }
        for (cell in cells)
        {
            // toute les cases voisines vierges et solides sont considérées comme des murs
            for (dir/* AS3HX WARNING could not determine type for var: dir exp: EField(EIdent(Level),ALL_DIRECTIONS) type: null */ in Level.ALL_DIRECTIONS)
            {
                neightbor = pLevel.getCell(cell.cx + dir.x, cell.cy + dir.y);
                if (neightbor.collide && neightbor.structure == null)
                {
                    neightbor.addMarker("wall");
                }
            }
            // les murs à coté d'une porte sont considéré comme des coins,
            // et donc ne sont pas valide comme case potencielle de couloir
            if (cell.haveMarker("door"))
            {
                for (dir/* AS3HX WARNING could not determine type for var: dir exp: EField(EIdent(Level),HV_DIRECTIONS) type: null */ in Level.HV_DIRECTIONS)
                {
                    neightbor = pLevel.getCell(cell.cx + dir.x, cell.cy + dir.y);
                    if (neightbor.haveMarker("wall"))
                    {
                        neightbor.addMarker("corner");
                    }
                }
            }
            
            cell.removeMarker("wall");
            cell.removeMarker("corner");
        }
    }
    
    
    public function merge(pCorridor : Corridor) : Void
    {
        cells = cells.concat(pCorridor.cells);
        for (struct in links.iterator)
        {
            links.putItem(struct);
        }
    }
    
    /* INTERFACE com.casusludi.lib.jammer.engines.level.ILevelStructure */
    
    private function get_markers() : Enumeration<String>
    {
        return _markers;
    }
    
    private function get_links() : Enumeration<ILevelStructure>
    {
        return _links;
    }
    
    public function toString() : String
    {
        return "[Corridor mainpath=" + markers.haveItem("mainpath") + "]";
    }
}

