package jammer.collections;

import flash.utils.Dictionary;
import haxe.ds.ObjectMap;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Enumeration<T>
{
    public var length(get, never) : Int;
    public var iterator(get, never) : Iterator<T>;

    
    private var _data : ObjectMap<Dynamic,Bool>;
    private var _length : Int;
    
    public function new()
    {
        _data = new ObjectMap<Dynamic,Bool>();
        _length = 0;
    }
    
    public function fill(pList : Iterable<T>) : Void
    {
        for (item in pList)
        {
            putItem(item);
        }
    }
    
    public function haveItem(pData : T) : Bool
    {
        return _data.exists(pData);
    }
    
    public function putItem(pData : T) : Void
    {
        if (!_data.exists(pData))
        {
            _length++;
        }
        _data.set(pData,true);
    }
    
    public function removeItem(pData : T) : Void
    {
        if (_data.exists(pData))
        {
            _length--;
            
            _data.remove(pData);
        }
    }
    
    public function pick() : T
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
    
    private function get_iterator() : Iterator<T>
    {
        return _data.keys();
    }
    
    public function toString() : String
    {
        var ret : Array<T> = [];
        for (item in _data.keys())
        {
            ret.push(item);
        }
        return "[Enumeration = " + Std.string(ret) + " ]";
    }
}

