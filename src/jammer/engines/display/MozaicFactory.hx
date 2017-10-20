package jammer.engines.display;

import jammer.utils.ColorUtils;
import flash.display.BitmapData;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class MozaicFactory
{
    
    public function new()
    {
    }
    
    public static function makeScanline(pSize : Int, pColor : Int = 0xFFFFFF) : BitmapData
    {
        var bd : BitmapData = new BitmapData(pSize, pSize, false, 0x808080);
        var x : Int = 0;
        var c : Int = pSize;
        while (x < c)
        {
            bd.setPixel(x, pSize - 1, pColor);
            x++;
        }
        return bd;
    }
    
    public static function makeMosaic(pSize : Int, pWhite : Float = 1.0, pBlack : Float = 1.0) : BitmapData
    {
        var bd : BitmapData = new BitmapData(pSize, pSize, true, 0x808080);
        
        var w : Int = ColorUtils.addAlphaF(0xE0E0E0, pWhite);
        var b : Int = ColorUtils.addAlphaF(0x0, pBlack);
        
        bd.setPixel32(0, 0, w);
        bd.setPixel32(pSize - 1, pSize - 1, b);
        var i : Int;
        var c : Int = pSize-1;
        for (i in 1...c)
        {
            bd.setPixel32(i, 0, w);
            bd.setPixel32(i, pSize - 1, b);
        }
        
        w = ColorUtils.addAlphaF(0xFFFFFF, pWhite);
        for (i in 1...c)
        {
            bd.setPixel32(0, i, w);
            bd.setPixel32(pSize - 1, i, b);
        }
        return bd;
    }
}

