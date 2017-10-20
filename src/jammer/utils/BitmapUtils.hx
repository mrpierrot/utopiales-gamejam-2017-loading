package jammer.utils;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.StageQuality;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class BitmapUtils
{
    
    public function new()
    {
    }
    
    private static var _destPoint : Point = new Point();
    
    /**
		 * Cette methode permet de decomposer un displayobject en un  bitmap 
		 * @param	pMc
		 * @return BitmapData
		 */
    @:meta(Inline())

    public static function flatten(pMc : DisplayObject) : BitmapData
    {
        var bmp : BitmapData;
        
        bmp = new BitmapData(Std.int(pMc.width), Std.int(pMc.height), true, 0);
        bmp.drawWithQuality(pMc, null, null, null, null, false, StageQuality.LOW);
        return bmp;
    }
    
    /**
		 * Cette methode permet de decomposer un displayobject en un  bitmap 
		 * @param	pMc
		 * @return BitmapData
		 */
    @:meta(Inline())

    public static function flattenWithQuality(pMc : DisplayObject, pQuality : StageQuality) : BitmapData
    {
        var bmp : BitmapData;
        
        bmp = new BitmapData(Std.int(pMc.width), Std.int(pMc.height), true, 0);
        bmp.drawWithQuality(pMc, null, null, null, null, false, pQuality);
        return bmp;
    }
    
    @:meta(Inline())

    public static function invert(pSource : BitmapData) : Void
    {
        // Replace all transparent pixels with a solid color
        pSource.threshold(pSource, pSource.rect, _destPoint, "==", 0x00000000, 0xFFFF0000);
        // Replace all the pixels greater than 0xf1f1f1 by transparent pixels
        pSource.threshold(pSource, pSource.rect, _destPoint, "==", 0xff656565, 0x0000FF00);
    }
}

