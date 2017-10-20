package jammer.utils;

import haxe.Constraints.Function;
import jammer.engines.display.types.JamTiles;
import jammer.engines.level.Cell;
import jammer.engines.level.gen.dungeon.Corridor;
import jammer.engines.level.gen.dungeon.Room;
import jammer.engines.level.Level;
import jammer.utils.MathUtils;
import jammer.utils.StringUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DungeonGeneratorUtils
{
    
    public function new()
    {
    }
    
    public inline static function getCellsHeuristic(pGoal : Cell, pNext : Cell) : Int
    {
        //return MathUtils.squareDistance(pGoal.cx, pGoal.cy, pNext.cx, pNext.cy);
        return MathUtils.iabs(pGoal.cy - pNext.cy) + MathUtils.iabs(pGoal.cx - pNext.cx);
    }
    
    
    public static function createCorridorNeighborsCellsFunction(pLevel : Level, pStart : Cell, pGoal : Cell, pUseExistingCorridors : Bool = true) : Cell->Array<Cell>
    {
        var neightbors : Array<Cell> = new Array<Cell>();
        var level : Level = pLevel;
        var start : Cell = pStart;
        var goal : Cell = pGoal;
        return function getCorridorNeighborsCells(pCurrent : Cell) : Array<Cell>
        {
            neightbors.splice(0, neightbors.length);
            var neightbor : Cell;
            var aCell : Cell;
            var cellG : Cell;
            var cellH : Cell;
            var cellI : Cell;
            for (dir in Level.HV_DIRECTIONS)
            {
                neightbor = level.getCell(pCurrent.cx + dir.x, pCurrent.cy + dir.y);
                
                /**
				 * 
				 *  Soit C la cellule courante
				 *  N la cellule entrain d'etre testé
				 *  A perpendiculaire à NC à gauche
				 *  B perpendiculaire à NC àdroite
				 *  E a coté de A et AE parallele à NC
				 *  F a coté de B et BE parallele à NC
				 *  G la cellule juste apres N
				 * 
				 *  +-+-+-+----
				 *  | |A|E
				 *  +-+-+-+----
				 *  |C|N|G
				 *  +-+-+-+----
				 *  | |B|F
				 *  +-+-+-+----
				 *  Si N est avec collision et 
				 *  au moins une des cellule A,E est une case sans collision alors N n'est pas un voisin exploitable
				 *  Si G est en collision alors E et F doivent l'etre aussi.
				 * 
				 */
                if (neightbor != null)
                {

					if (!neightbor.haveMarker("corner"))
					{
						
						if (!neightbor.haveMarker("door"))
						{

							if (neightbor.collide)
							{
								//trace("current : " + pCurrent);
								//trace("neightbor : "+neightbor);
								var dx : Int = Std.int(neightbor.cx - pCurrent.cx);
								var dy : Int = Std.int(neightbor.cy - pCurrent.cy);
								
								var ax : Int = Std.int(neightbor.cx - dy);
								var ay : Int = Std.int(neightbor.cy - dx);
								
								var 
								
								aCell = level.getCell(ax, ay);
								if (!(aCell == null || !aCell.collide))
								{
								
									var bx : Int = Std.int(neightbor.cx + dy);
									var by : Int = Std.int(neightbor.cy + dx);
									aCell = level.getCell(bx, by);
									if (!(aCell == null || !aCell.collide))
									{
										
									
										var gx : Int = Std.int(neightbor.cx + dx);
										var gy : Int = Std.int(neightbor.cy + dy);
										cellG = level.getCell(gx, gy);
										if (cellG != null)
										{
											var ex : Int = Std.int(ax + dx);
											var ey : Int = Std.int(ay + dy);
											aCell = level.getCell(ex, ey);
											if (!(aCell == null || !aCell.collide && cellG.collide))
											{
												
												if (!(aCell.collide && !cellG.collide))
												{
													
												
													var fx : Int = Std.int(bx + dx);
													var fy : Int = Std.int(by + dy);
													aCell = level.getCell(fx, fy);
													if (!(aCell == null || !aCell.collide && cellG.collide))
													{
														
														if (!(aCell.collide && !cellG.collide))
														{
															neightbors.push(neightbor);
														}
													}
												}
											}
										}
									}
									
								}
								
								/*var hx:int = pCurrent.cx - dy;
									var hy:int = pCurrent.cy - dx;
									cellH = level.getCell(hx, hy);
									if (!cellH) continue;
									
									var ix:int = pCurrent.cx + dy;
									var iy:int = pCurrent.cy + dx;
									cellI = level.getCell(ix, iy);
									if (!cellI) continue;*/
								//if (cellI.collide != cellH.collide) continue;
								
								//trace("added");
							  
							}
							else
							{
								if (
									// si la cellule voisine n'a pas encore de structure définit
									neightbor.structure == null
									|| neightbor.structure ==start.structure
									|| neightbor.structure == goal.structure
									|| pUseExistingCorridors && Std.is(neightbor.structure, Corridor)  // si la cellule voisine fait partie de la piece d'arrivé    // si la cellule voisine fait partie de la piece de depart  )
								){
									neightbors.push(neightbor);
								}
							}
						}
					}
				}
			}
            //trace("neightbors count : "+neightbors.length)
            return neightbors;
        };
    }
    
    public static function toStringDungeonCellRender(pCell : Cell) : String
    {
        if (Std.is(pCell.structure, Room))
        {
            var room : Room = cast((pCell.structure), Room);
            if (room.center == pCell)
            {
                if (room.markers.haveItem("start"))
                {
                    return "(S)";
                }
                if (room.markers.haveItem("end"))
                {
                    return "(E)";
                }
                
                return StringUtils.complete(Std.string(room.id), " ", 2) + ((room.markers.haveItem("mainpath")) ? "*" : " ");
            }
        }
        
        
        /*if (pCell.properties.struct is Corridor) {
				return ".";
			}*/
        if (pCell.haveMarker("corner"))
        {
            return "[+]";
        }
        if (pCell.haveMarker("door"))
        {
            return " / ";
        }
        if (pCell.haveMarker("wall"))
        {
            return "[#]";
        }
        /*if (pCell.structure is Corridor) {
				return pCell.structure.markers.haveItem("mainpath")?"¨":"";
			}*/
        
        if (pCell.haveMarker("floor"))
        {
            return " . ";
        }
        
        return (pCell.collide) ? "   " : "   ";
    }
}

