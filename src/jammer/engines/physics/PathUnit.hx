package jammer.engines.physics;

import flash.errors.Error;
import jammer.collections.LinkedList;
import jammer.collections.Node;
import jammer.collections.NodePool;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.level.Cell;
import jammer.utils.MathUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class PathUnit extends Unit
{
    public var path : LinkedList;
    private var _currentNode : Node;
    private var _currentCell : Cell;
    private var _previousCell : Cell;
    private var _pausedNode : Node;
    private var _pausedCell : Cell;
    public var loop : Bool;
    public var reverseLoop : Bool;
    public var paused : Bool;
    public var reversed : Bool;
    public var targetMode : Bool;
    public var skipNextNode : Bool;
    
    public function new(pSkin : JamAnimation, pPathNodePool : NodePool = null)
    {
        path = new LinkedList(pPathNodePool, Cell);
        loop = reverseLoop = paused = reversed = false;
        super(pSkin);
    }
    
    public function start() : Void
    {
        if (targetMode)
        {
            if (level == null)
            {
                throw new Error("PathUnit.level undefined");
            }
            if (paused)
            {
                _pausedCell = level.getCell(cx, cy);
                if (_pausedCell != null)
                {
                    _pausedCell = _pausedCell.next;
                }
            }
            else
            {
                _currentCell = level.getCell(cx, cy);
                if (_currentCell != null)
                {
                    _currentCell = _currentCell.next;
                }
            }
        }
        else
        {
            if (paused)
            {
                _pausedNode = path.head;
            }
            else
            {
                _currentNode = path.head;
            }
        }
    }
    
    public function addPathPoint(pCx : Int, pCy : Int) : Void
    {
        var node : Node = path.create();
        if (node != null)
        {
            var cell : Cell = node.data;
            cell.cx = pCx;
            cell.cy = pCy;
        }
    }
    
    override public function command(pDelta : Float = 1.0) : Void
    {
        dirX = dirY = 0;
        if (!paused)
        {
            if (_pausedNode != null || _pausedCell != null)
            {
                _currentNode = _pausedNode;
                _pausedNode = null;
                _currentCell = _pausedCell;
                _pausedCell = null;
            }
            if (targetMode)
            {
                var next : Cell = level.getCell(cx, cy);
                if (_currentCell == null && next != null && next.next != null)
                {
                    _currentCell = next.next;
                }
            }
        }
        if (!targetMode && _currentNode != null || _currentCell != null)
        {
            var cell : Cell = (targetMode) ? _currentCell : _currentNode.data;
            if (
                isLevelCollide || skipNextNode ||
                (
                (cx == cell.cx && ((lastdx >= 0 && xr >= 0.4) || (lastdx <= 0 && xr <= 0.6) || (xr == 0.5)))
                && (cy == cell.cy && ((lastdy >= 0 && yr >= 0.4) || (lastdy <= 0 && yr <= 0.6) || (yr == 0.5)))))
            {
                skipNextNode = false;
                if (targetMode)
                {
                    if (_previousCell != null && cell.next != null)
                    {
                        if (_previousCell.cx != cell.cx &&  cell.cx != cell.next.cx)
                        {
                            yr = 0.5;
                            dy /= 6;
                        }
                        if (_previousCell.cy != cell.cy &&  cell.cy != cell.next.cy)
                        {
                            xr = 0.5;
                            dx /= 6;
                        }
                    }
                    
                    _previousCell = _currentCell;
                    _currentCell = _currentCell.next;
                    //trace(_currentCell);
                    if (_currentCell == null)
                    {
                        yr = 0.5;
                        dy /= 6;
                        xr = 0.5;
                        dx /= 6;
                        pathCompleted();
                    }
                    else
                    {
                        dirY = (_currentCell.cy + 0.5) - (cy + yr);
                        dirX = (_currentCell.cx + 0.5) - (cx + xr);
                    }
                }
                else
                {
                    if (_currentNode.previous != null && _currentNode.next != null)
                    {
                        if (_currentNode.previous.data.cx != cell.cx != _currentNode.next.data.cx)
                        {
                            yr = 0.5;
                            //dy = 0;
                            dy /= 6;
                        }
                        if (_currentNode.previous.data.cy != cell.cy != _currentNode.next.data.cy)
                        {
                            xr = 0.5;
                            //dx = 0;
                            dx /= 6;
                        }
                    }
                    _currentNode = (reversed) ? _currentNode.previous : _currentNode.next;
                    if (_currentNode == null)
                    {
                        yr = 0.5;
                        dy /= 6;
                        xr = 0.5;
                        dx /= 6;
                        pathCompleted();
                        if (loop)
                        {
                            _currentNode = path.head;
                        }
                        else
                        {
                            if (reverseLoop)
                            {
                                reversed = !reversed;
                                _currentNode = (reversed) ? path.tail : path.head;
                            }
                        }
                    }
                    else
                    {
                        cell = _currentNode.data;
                        dirY = (cell.cy + 0.5) - (cy + yr);
                        dirX = (cell.cx + 0.5) - (cx + xr);
                    }
                    
                    if (_currentNode != null && paused)
                    {
                        _pausedNode = _currentNode;
                        _currentNode = null;
                    }
                }
            }
            else
            {
                dirY = (cell.cy + 0.5) - (cy + yr);
                dirX = (cell.cx + 0.5) - (cx + xr);
            }
        }
    }
    
    public function clearPath() : Void
    {
        path.clear();
    }
	
	public function stop() : Void
    {
        clearPath();
		_currentCell = null;
		_currentNode = null;
		_previousCell = null;
		_pausedCell = null;
		_pausedNode = null;
		
    }
    
    private function pathCompleted() : Void
    {
    }
}

