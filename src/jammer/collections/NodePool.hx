package jammer.collections;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class NodePool
{
    public var size(get, never) : Int;
    public var type(get, never) : Class<Dynamic>;

    
    public var growthCount : Int;
    private var _size : Int;
    private var _type : Class<Dynamic>;
    private var _head : Node;
    
    public function new(pType : Class<Dynamic>, pInitCount : Int = 100, pGrowthCount : Int = 100)
    {
        _type = pType;
        growthCount = pGrowthCount;
        _size = 0;
        growingPool(pInitCount);
    }
    
    @:meta(Inline())

    @:final public function growingPool(pCount : Int) : Void
    {
        var node : Node;
        while (pCount > 0)
        {
            node = new Node(Type.createInstance(_type, []));
            if (_head != null)
            {
                _head.previous = node;
                node.next = _head;
            }
            _head = node;
            pCount--;
            _size++;
        }
    }
    
    @:meta(Inline())

    @:final public function create() : Node
    {
        if (_head == null)
        {
            growingPool(growthCount);
        }
        if (_head != null)
        {
            var node : Node = _head;
            _head = node.next;
            if (_head != null)
            {
                _head.previous = null;
            }
            node.previous = node.next = null;
            _size--;
            return node;
        }
        return null;
    }
    
    @:meta(Inline())

    @:final public function dispose(pNode : Node) : Void
    {
        if (pNode == null)
        {
            return;
        }
        if (_head != null)
        {
            _head.previous = pNode;
            pNode.previous = null;
            pNode.next = _head;
            _head = pNode;
        }
        else
        {
            _head = pNode;
            _head.previous = _head.next = null;
        }
        _size++;
    }
    
    @:meta(Inline())

    @:final private function get_size() : Int
    {
        return _size;
    }
    
    @:meta(Inline())

    @:final private function get_type() : Class<Dynamic>
    {
        return _type;
    }
}

