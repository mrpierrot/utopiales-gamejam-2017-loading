package jammer.collections;

import haxe.ds.StringMap;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class StringEnumeration
{
    public var length(get, never) : Int;
    public var iterator(get, never) : Iterator<String>;

    
    private var _data : StringMap<Bool>;
    private var _length : Int;
    
    public function new()
    {
        _data = new StringMap<Bool>();
        _length = 0;
    }
    
    public function fill(pList : Iterable<String>) : Void
    {
        for (item in pList)
        {
            putItem(item);
        }
    }
    
    public function haveItem(pData : String) : Bool
    {
        /*trace(pData,_data.get(pData),_data.exists(pData));
        for (item in _data.keys())
        {
            trace(item,pData,pData==item);
        }*/
        return _data.get(pData);
    }
    
    public function putItem(pData : String) : Void
    {
        //trace("add "+pData+" to "+this.toString(),_data.exists(pData));
        if (!_data.exists(pData))
        {
            _length++;
        }
        _data.set(pData,true);
       // trace(" => "+this.toString());
    }
    
    public function removeItem(pData : String) : Void
    {
        if (_data.exists(pData))
        {
            _length--;
            
            _data.remove(pData);
        }
    }
    
    public function pick() : String
    {
        for (item in _data.keys())
        {
            _length--;
            _data.remove(item);
            return item;
        }
		return null;
    }
    
    private function get_length() : Int
    {
        return _length;
    }
    
    private function get_iterator() : Iterator<String>
    {
        return _data.keys();
    }
    
    public function toString() : String
    {
        var ret : Array<String> = [];
        for (item in _data.keys())
        {
            ret.push(item);
        }
        return "[StringEnumeration = " + Std.string(ret) + " ]";
    }
}