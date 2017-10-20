package jammer.engines.display;

import jammer.engines.display.types.JamDisplayObject;
import flash.display.IBitmapDrawable;
import flash.events.EventDispatcher;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Layer extends JamDisplayObject
{
    public var name(get, never) : String;

    
    private var _name : String;
    public var size : Int;
    
    public function new(pName : String)
    {
        super();
        _name = pName;
        size = 0;
    }
    
    private function get_name() : String
    {
        return _name;
    }
    
    override public function toString() : String
    {
        return "[Layer name=" + name + "]";
    }
}

