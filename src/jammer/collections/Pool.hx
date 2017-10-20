package jammer.collections;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Pool
{
    public var size(get, never) : Int;
    public var type(get, never) : Class<Dynamic>;

    
    public var growthCount : Int;
    private var _size : Int;
    private var _type : Class<Dynamic>;
    private var _head : Node;
    private var _list : Array<Dynamic>;
    
    public function new(pType : Class<Dynamic>, pInitCount : Int = 100, pGrowthCount : Int = 100)
    {
        _type = pType;
        growthCount = pGrowthCount;
        _size = 0;
        _list = new Array<Dynamic>();
        growingPool(pInitCount);
    }
    
    inline public function growingPool(pCount : Int) : Void
    {
        var item : Dynamic;
        while (pCount > 0)
        {
            _list.push(Type.createInstance(_type, []));
            pCount--;
        }
        _size = _list.length;
    }
    

    inline public function create() : Dynamic
    {
        if (_size <= 0)
        {
            growingPool(growthCount);
        }
        if (_size > 0)
        {
            var item : Dynamic = _list.pop();
            _size--;
            return item;
        }
        return null;
    }
    
    inline public function dispose(pItem : Dynamic) : Void
    {
        if (pItem == null)
        {
            return;
        }
        _list.push(pItem);
        _size++;
    }
    
    inline private function get_size() : Int
    {
        return _size;
    }
    
    inline private function get_type() : Class<Dynamic>
    {
        return _type;
    }
}

