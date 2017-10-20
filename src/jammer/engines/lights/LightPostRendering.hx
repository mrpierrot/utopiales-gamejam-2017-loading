package jammer.engines.lights;

import haxe.Constraints.Function;
import jammer.engines.display.types.JamBitmap;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.utils.EaseUtils;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.BlendMode;
import flash.display.StageQuality;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LightPostRendering
{
    
    public function new()
    {
    }
    
    
    private static var _destPoint : Point = new Point();
    
    
    public static function createHalo(pHaloColor : Int = 0xf9f8ce, pHaloSize : Int = 2, pTileWidth : Int = 16, pTileHeight : Int = 16) : BitmapData->Rectangle->Point->JamBitmap->Void
    {
        var blurFilterA : BlurFilter = new BlurFilter(pTileWidth, pTileHeight, 3);
        var blurFilterB : BlurFilter = new BlurFilter(pTileWidth * 0.5, pTileHeight * 0.5, 3);
        var glowFilterA : GlowFilter = new GlowFilter(pHaloColor, 1, pHaloSize, pHaloSize, 10, 1, true);
        return function(pRendering : BitmapData, pSourceRect : Rectangle, pDestPoint : Point, pContainer : JamBitmap) : Void
        {
            var bmp : BitmapData = pRendering.clone();
            pRendering.applyFilter(pRendering, pSourceRect, pDestPoint, blurFilterA);
            pRendering.applyFilter(pRendering, pSourceRect, pDestPoint, glowFilterA);
            
            bmp.applyFilter(bmp, pSourceRect, pDestPoint, blurFilterB);
            pRendering.draw(bmp, null, null, BlendMode.MULTIPLY);
        };
    }
    
    public static function createPillowShading(pTileWidth : Int = 16, pTileHeight : Int = 16, pThresholdCount : Int = 14, pHaloSmoothRate : Float = 1) : BitmapData->Rectangle->Point->JamBitmap->Void
    {
        var haloSmoothRate : Float = pHaloSmoothRate;
        var blurFilterA : BlurFilter = new BlurFilter(pTileWidth * haloSmoothRate, pTileHeight * haloSmoothRate, 1);
        var newBmp : BitmapData = null;
        var bmp : BitmapData = null;
        return function(pRendering : BitmapData, pSourceRect : Rectangle, pDestPoint : Point, pContainer : JamBitmap) : Void
        {
            if (newBmp != null)
            {
                newBmp.fillRect(pSourceRect, 0);
                bmp.copyPixels(pRendering, pSourceRect, pDestPoint);
            }
            else
            {
                newBmp = new BitmapData(pRendering.width, pRendering.height, true, 0);
                bmp = pRendering.clone();
            }
            
            pRendering.applyFilter(pRendering, pSourceRect, pDestPoint, blurFilterA);
            bmp.copyPixels(pRendering, pSourceRect, pDestPoint, null, null, false);
            
            var ease : Function = EaseUtils.easeLinear;
            var rate : Float = ease(1 / pThresholdCount);
            
            var alpha : Int = Std.int(255 * rate) << 24;
            newBmp.threshold(pRendering, pSourceRect, pDestPoint, "<", alpha, 0x0000000, 0xFF000000);
            for (i in 1...pThresholdCount - 1)
            {
                rate = ease(i / pThresholdCount);
                alpha = Std.int(255 * rate) << 24;
                newBmp.threshold(pRendering, pSourceRect, pDestPoint, ">=", alpha, alpha, 0xFF000000);
            }
            rate = ease(pThresholdCount - 1 / pThresholdCount);
            alpha = Std.int(255 * rate) << 24;
            newBmp.threshold(pRendering, pSourceRect, pDestPoint, ">=", alpha, 0xFF00000, 0xFF000000);
            
            
            
            
            //pRendering.copyChannel(newBmp, pSourceRect, pDestPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            pRendering.copyPixels(newBmp, pSourceRect, pDestPoint);
            
            pRendering.copyPixels(bmp, pSourceRect, pDestPoint, null, null, true);
        };
    }
    
    
    public static function createBlur(pTileWidth : Int = 16, pTileHeight : Int = 16) : BitmapData->Rectangle->Point->JamBitmap->Void
    {
        var blurFilterB : BlurFilter = new BlurFilter(pTileWidth * 0.5, pTileHeight * 0.5, 3);
        return function blur(pRendering : BitmapData, pSourceRect : Rectangle, pDestPoint : Point, pContainer : JamBitmap) : Void
        {
            pRendering.applyFilter(pRendering, pSourceRect, pDestPoint, blurFilterB);
        };
    }
    
    
    public static function createDarkMask(pTileWidth : Int = 16, pTileHeight : Int = 16, pDarkSmoothRate : Float = 0.4) : Function
    {
        var darkSmoothRate : Float = pDarkSmoothRate;
        var glowFilterA : GlowFilter = new GlowFilter(0x000000, 1, pTileWidth * darkSmoothRate, pTileHeight * darkSmoothRate, 5, 3, true);
        var blurFilterA : BlurFilter = new BlurFilter(pTileWidth * darkSmoothRate, pTileHeight * darkSmoothRate, 3);
        return function(pRendering : BitmapData, pSourceRect : Rectangle, pDestPoint : Point, pContainer : JamBitmap) : BitmapData
        {
            var borderBmp : BitmapData = new BitmapData(pRendering.width, pRendering.height, true, 0xFFFF0000);
            borderBmp.threshold(pRendering, pRendering.rect, _destPoint, "<=", 0x00FFFFFF, 0x00FFFFFF, 0xFF000000);
            
            borderBmp.applyFilter(borderBmp, borderBmp.rect, _destPoint, glowFilterA);
            borderBmp.applyFilter(borderBmp, borderBmp.rect, _destPoint, blurFilterA);
            
            var borderBmp2 : BitmapData = new BitmapData(pRendering.width, pRendering.height, true, 0xFF000000);
            
            borderBmp2.copyChannel(borderBmp, borderBmp.rect, _destPoint, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
            
            return borderBmp2;
        };
    }
}




