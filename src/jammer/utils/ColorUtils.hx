package jammer.utils;

import flash.geom.ColorTransform;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class ColorUtils
{
    
    public function new()
    {
    }
    
    @:meta(Inline())

    
    public static function addAlphaF(c : Int, a : Float) : Int
    {
        return Std.int(Std.int(a * 255) << 24 | c);
    }
    
    /**
		 * sets brightness value available are -100 ~ 100 @default is 0
		 * @param 		value:int	brightness value
		 * @return		ColorMatrixFilter
		 */
    @:meta(Inline())

    public static function adjustBrightness(pColoTransform : ColorTransform, value : Float) : Void
    {
        value = value * (255);
        pColoTransform.redOffset = value;
        pColoTransform.greenOffset = value;
        pColoTransform.blueOffset = value;
    }
    
    @:meta(Inline())

    public static function createRGBColor(pR : Float = 1.0, pG : Float = 1.0, pB : Float = 1.0) : Int
    {
        return Std.int(Std.int(pR * 255) << 16 | Std.int(pG * 255) << 8 | Std.int(pB * 255));
    }
    
    @:meta(Inline())

    public static function createARGBColor(pR : Float = 1.0, pG : Float = 1.0, pB : Float = 1.0, pA : Float = 0.8) : Int
    {
        var c : Int = Std.int(Std.int(pA * 255) << 24 | Std.int(pR * 255) << 16 | Std.int(pG * 255) << 8) | Std.int(pB * 255);
        return c;
    }
    
    @:meta(Inline())

    // Operation A sur B
    public static function alphaBlend(pFG : Int, pBG : Int) : Int
    {
        // 0xDDFFCCEE
        var aFG : Int = Std.int(pFG & 0xFF000000) >>> 24;
        var rFG : Int = Std.int(pFG & 0x00FF0000) >>> 16;
        var gFG : Int = Std.int(pFG & 0x0000FF00) >>> 8;
        var bFG : Int = Std.int(pFG & 0x000000FF);
        
        var aBG : Int = Std.int(pBG & 0xFF000000) >>> 24;
        var rBG : Int = Std.int(pBG & 0x00FF0000) >>> 16;
        var gBG : Int = Std.int(pBG & 0x0000FF00) >>> 8;
        var bBG : Int = Std.int(pBG & 0x000000FF);
        
        //trace(aFG.toString(16), rFG.toString(16),gFG.toString(16),bFG.toString(16));
        
        
        var aR : Int = Std.int(aFG + aBG * (255 - aFG) / 255);
        var rR : Int = Std.int((rFG * aFG + rBG * aBG * (255 - aFG) / 255) / aR);
        var gR : Int = Std.int((gFG * aFG + gBG * aBG * (255 - aFG) / 255) / aR);
        var bR : Int = Std.int((bFG * aFG + bBG * aBG * (255 - aFG) / 255) / aR);
        
        var r : Int = Std.int(aR << 24 | rR << 16 | gR << 8) | bR;
        
        return r;
    }
}

