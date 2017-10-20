package jammer.engines.pathfinding;

import jammer.collections.LinkedList;
import jammer.collections.NodePool;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class BreadthFirstSearch
{
    
    
    private static var _frontiers : Array<Cell> = new Array<Cell>();
    
    
    public inline static function update(pLevel : Level, pCx : Int, pCy : Int) : Void
    {
        _frontiers.splice(0, _frontiers.length);
        var start : Cell = pLevel.getCell(pCx, pCy);
        var cell : Cell;
        var neightboor : Cell;
        var count : Int = 1;
        if (start != null && !start.collide)
        {
            var i : Int = 0;
            var c : Int = pLevel.cells.length;
            while (i < c)
            {
                pLevel.cells[i].next = null;
                i++;
            }
            _frontiers.push(start);
            while (count > 0)
            {
                cell = _frontiers.shift();
                count--;
                if (cell.cy + 1 < pLevel.rows)
                {
                    neightboor = pLevel.cells[cell.cx + (cell.cy + 1) * pLevel.cols];
                    if (neightboor != null && neightboor != start && neightboor.next == null && !neightboor.collide)
                    {
                        _frontiers.push(neightboor);
                        count++;
                        neightboor.next = cell;
                    }
                }
                if (cell.cy - 1 >= 0)
                {
                    neightboor = pLevel.cells[cell.cx + (cell.cy - 1) * pLevel.cols];
                    if (neightboor != null && neightboor != start && neightboor.next ==null && !neightboor.collide)
                    {
                        _frontiers.push(neightboor);
                        count++;
                        neightboor.next = cell;
                    }
                }
                if (cell.cx + 1 < pLevel.cols)
                {
                    neightboor = pLevel.cells[(cell.cx + 1) + cell.cy * pLevel.cols];
                    if (neightboor != null && neightboor != start && neightboor.next == null && !neightboor.collide)
                    {
                        _frontiers.push(neightboor);
                        count++;
                        neightboor.next = cell;
                    }
                }
                if (cell.cy - 1 >= 0)
                {
                    neightboor = pLevel.cells[(cell.cx - 1) + cell.cy * pLevel.cols];
                    if (neightboor != null && neightboor != start && neightboor.next == null && !neightboor.collide)
                    {
                        _frontiers.push(neightboor);
                        count++;
                        neightboor.next = cell;
                    }
                }
            }
        }
    }

    public function new()
    {
    }
}

