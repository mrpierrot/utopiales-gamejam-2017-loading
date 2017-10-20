package jammer.engines.pathfinding;

import haxe.Constraints.Function;
import jammer.collections.PriorityQueue;
import jammer.engines.level.Cell;
import haxe.ds.ObjectMap;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class AStar
{
    
    public function new()
    {
    }
    
    public static function search<T>(pStart : T, pGoal : T, pNeighbors : T->Array<T>, pHeuristic : T->T->Int, pCost : T->T->Int) : ObjectMap<Dynamic,Dynamic>
    {
        var frontier : PriorityQueue = new PriorityQueue();
        frontier.insert(pGoal, 0);
        
        var cameFrom : ObjectMap<Dynamic,Dynamic> = new ObjectMap<Dynamic,Dynamic>();
        var costSoFar : ObjectMap<Dynamic,Int> = new ObjectMap<Dynamic,Int>();
        
        cameFrom.set(pGoal,null);
        costSoFar.set(pGoal,0);
        
        var current : Dynamic;
        var newCost : Int;
        while (!frontier.empty())
        {
            current = frontier.removeFirst();
            if (current == pStart)
            {
                break;
            }
            for (next in pNeighbors(current))
            {
                newCost = costSoFar.get(current) + pCost(current, next);
                if (!costSoFar.exists(next) || newCost < costSoFar.get(next))
                {
                    costSoFar.set(next,newCost);
                    frontier.insert(next, newCost + pHeuristic(pGoal, next));
                    cameFrom.set(next,current);
                }
            }
        }
        
        return cameFrom;
    }
}

