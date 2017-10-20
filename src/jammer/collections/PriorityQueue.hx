package jammer.collections;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class PriorityQueue
{
    
    public static var pool : Pool;
    
    private var _list : Array<PQNode>;
    
    public function new()
    {
        if (pool == null)
        {
            pool = new Pool(PQNode);
        }
        _list = new Array<PQNode>();
    }
    
    public function insert(pItem : Dynamic, pPriority : Int) : Void
    {
        var node : PQNode = pool.create();
        node.item = pItem;
        node.priority = pPriority;
        var i : Int = Std.int(_list.push(node) - 1);
        _siftUp(i);
    }
    
    
    public function removeFirst() : Dynamic
    {
        if (_list.length == 0)
        {
            return null;
        }
        var first : PQNode = _list[0];
        var lastIndex : Int = Std.int(_list.length - 1);
        _list[0] = _list[lastIndex];
        _siftDown(0);
        _list.pop();
        var item : Dynamic = first.item;
        pool.dispose(first);
        return item;
    }
    
    public function empty() : Bool
    {
        return _list.length == 0;
    }
    
    private function _siftUp(pIndex : Int) : Void
    {
        var parentIndex : Int = Std.int((pIndex - 1) / 2);
        var parent : PQNode = _list[parentIndex];
        var current : PQNode = _list[pIndex];
        if (parent.priority > current.priority)
        {
            _list[parentIndex] = current;
            _list[pIndex] = parent;
            _siftUp(parentIndex);
        }
    }
    
    private function _siftDown(pIndex : Int) : Void
    {
        var leftIndex : Int = Std.int(pIndex * 2 + 1);
        var rightIndex : Int = Std.int(pIndex * 2 + 2);
        var size : Int = _list.length;
        var smallestIndex : Int = pIndex;
        
        if (leftIndex < size && _list[leftIndex].priority < _list[smallestIndex].priority)
        {
            smallestIndex = leftIndex;
        }
        if (rightIndex < size && _list[rightIndex].priority < _list[smallestIndex].priority)
        {
            smallestIndex = rightIndex;
        }
        if (smallestIndex != pIndex)
        {
            var item : PQNode = _list[pIndex];
            _list[pIndex] = _list[smallestIndex];
            _list[smallestIndex] = item;
            _siftDown(smallestIndex);
        }
    }
    
    public function toString() : String
    {
        return "[Heap list=" + _list + " ]";
    }
}





class PQNode
{
    
    public var item : Dynamic;
    public var priority : Int;
    
    public function new()
    {
    }
    
    public function toString() : String
    {
        return "[PQNode item=" + item + " priority=" + priority + "]";
    }
}