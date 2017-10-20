package jammer.engines.level;

import jammer.collections.Enumeration;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Cell
{
    
    
    public var cx : Int;
    public var cy : Int;
    public var properties : Dynamic;
    public var markers : Enumeration<String>;
    public var collide : Bool;
    public var opaque : Bool;
    public var structure : ILevelStructure;
    public var level : Level;
    // Breadth first search attr
    public var next : Cell;
    // fog of war
    public var discovered : Float;
    // light engine
    public var brightness : Float;
    
    public function new(pLevel : Level, pCx : Int = 0, pCy : Int = 0, pMarkers : Enumeration<String> = null, pProperties : Dynamic = null)
    {
        level = pLevel;
        cx = pCx;
        cy = pCy;
        opaque = collide = false;
        properties = (pProperties != null) ? pProperties : { };
        markers = (pMarkers != null) ? pMarkers : new Enumeration<String>();
        brightness = 0;
        discovered = 0;
    }
    
    public function addMarker(pMarker : String) : Void
    {
        //level.addMarker(pMarker, this.cx, this.cy)
        if (!markers.haveItem(pMarker))
        {
            markers.putItem(pMarker);
            level._addMarker(pMarker, this);
        }
    }
    
    public function removeMarker(pMarker : String) : Void
    {
        //level.removeMarker(pMarker, this.cx, this.cy)
        if (markers.haveItem(pMarker))
        {
            markers.removeItem(pMarker);
            level._removeMarker(pMarker, this);
        }
    }
    
    public function haveMarker(pMarker : String) : Bool
    {
        return markers.haveItem(pMarker);
    }
    
    public function toString() : String
    {
        return "[Cell cx=" + cx + " cy=" + cy + " properties=" + properties + " markers=" + markers + " collide=" + collide +
        " opaque=" + opaque + " next=" + ((next != null) ? "[Cell cx=" + next.cx + " cy=" + next.cy + " ]" : "null") + " discovered=" + discovered + " brightness=" + brightness +
        "]";
    }
}

