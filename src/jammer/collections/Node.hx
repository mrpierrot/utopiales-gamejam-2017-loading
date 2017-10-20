package jammer.collections;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Node
{
    public var next : Node;
    public var previous : Node;
    public var data : Dynamic;
    
    public function new(pData : Dynamic = null)
    {
        data = pData;
        next = previous = null;
    }
    
    public function toString() : String
    {
        return "[Node previous=" + ((previous != null) ? "[Node]" : "null") + " next=" + ((next != null) ? "[Node]" : "null") + " data=" + data + "]";
    }
}

