package jammer.engines.display.assets;

import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Asset
{
    private static var _destPoint : Point = new Point();
    public var name : String;
    public var data : BitmapData;
    public var source : Rectangle;
    
    public function new(pName : String, pData : BitmapData, pSource : Rectangle = null)
    {
        name = pName;
        data = pData;
        source = pSource;
    }
    
    public function clone(pBitmap : Bool = false) : Asset
    {
        return new Asset(name, (pBitmap) ? data.clone() : data, (source != null) ? source.clone() : null);
    }
    
    public function applyFilter(pBitmapFilter : BitmapFilter) : Void
    {
        data.applyFilter(data, data.rect, _destPoint, pBitmapFilter);
    }
}

