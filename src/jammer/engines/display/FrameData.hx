package jammer.engines.display;

import flash.errors.Error;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class FrameData
{
    public var drawable : DisplayObject;
    public var asset : BitmapData;
    public var source : Rectangle;
    public var destination : Point;
    
    public function new(pAsset : Dynamic)
    {
        if (Std.is(pAsset, BitmapData))
        {
            /*drawable = */asset = pAsset;
            source = new Rectangle();
        }
        else
        {
            if (Std.is(pAsset, DisplayObject))
            {
                drawable = pAsset;
            }
        }
        if (drawable == null && asset == null)
        {
            throw new Error("FrameData must contain BitmapData or Flash display object asset");
        }
        destination = new Point();
    }
    
    public function getBounds() : Rectangle
    {
        if (asset != null)
        {
            return source;
        }
        if (drawable != null)
        {
            return drawable.getBounds(drawable);
        }
        return null;
    }
    
    public function toString() : String
    {
        return "[FrameData drawable=" + drawable + " asset=" + asset + " source=" + source + " destination=" + destination +
        "]";
    }
}

