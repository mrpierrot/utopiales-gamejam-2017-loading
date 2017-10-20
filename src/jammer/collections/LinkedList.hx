package jammer.collections;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LinkedList
{
    
    private var _pool : NodePool;
    private var _type : Class<Dynamic>;
    
    public var head : Node;
    public var tail : Node;
    
    
    public function new(pPool : NodePool = null, pType : Class<Dynamic> = null)
    {
        _pool = pPool;
        if (_pool != null)
        {
            _type = _pool.type;
        }
        else
        {
            _type = pType;
        }
    }
    
    public inline function create() : Dynamic
    {
        var node : Node;
        if (_pool != null)
        {
            node = _pool.create();
        }
        else
        {
            if (_type == null)
            {
                node = null;
            }else{
				node = new Node(Type.createInstance(_type, []));
			}
        }
        if (node != null)
        {
            if (tail != null)
            {
                node.previous = tail;
                node.next = null;
                tail.next = node;
                tail = node;
            }
            else
            {
                head = tail = node;
                node.next = node.previous = null;
            }
        }
        return node;
    }

    public inline function append(pData : Dynamic) : Node
    {
        var node : Node;
        if (_pool != null)
        {
            node = _pool.create();
        }
        else
        {
            node = new Node();
        }
        if (node != null)
        {
            node.data = pData;
            if (tail != null)
            {
                node.previous = tail;
                tail.next = node;
                tail = node;
            }
            else
            {
                head = tail = node;
                node.next = node.previous = null;
            }
        }
        return node;
    }
    

	public inline function prepend(pData : Dynamic) : Node
    {
        var node : Node;
        if (_pool != null)
        {
            node = _pool.create();
        }
        else
        {
            node = new Node();
        }
        if (node != null)
        {
            node.data = pData;
            if (head != null)
            {
                node.next = head;
                head.previous = node;
                head = node;
            }
            else
            {
                head = tail = node;
                node.next = node.previous = null;
            }
        }
        return node;
    }
    
    public inline function remove(pNode : Node) : Dynamic
    {
        if (pNode == null)
        {
            return null;
        }
        if (pNode == head)
        {
            head = head.next;
            if (head != null)
            {
                head.previous = null;
            }
        }
        if (pNode == tail)
        {
            tail = tail.previous;
            if (tail != null)
            {
                tail.next = null;
            }
        }
        if (pNode.previous != null)
        {
            pNode.previous.next = pNode.next;
        }
        if (pNode.next != null)
        {
            pNode.next.previous = pNode.previous;
        }
        if (_pool != null)
        {
            _pool.dispose(pNode);
        }
        return pNode.data;
    }
    
    public inline function removeHead() : Dynamic
    {
        var node : Node = head;
        head = head.next;
        if (head != null)
        {
            head.previous = null;
        }
        if (node == tail)
        {
            tail = tail.previous;
            if (tail != null)
            {
                tail.next = null;
            }
        }
        if (node.previous != null)
        {
            node.previous.next = node.next;
        }
        if (node.next != null)
        {
            node.next.previous = node.previous;
        }
        if (_pool != null)
        {
            _pool.dispose(node);
        }
        return node.data;
    }
    
	public inline function clear() : Void
    {
        if (_pool != null && head != null)
        {
            var node : Node = head;
            while (node != null)
            {
                _pool.dispose(node);
                node = node.next;
            }
        }
        head = tail = null;
    }
}

