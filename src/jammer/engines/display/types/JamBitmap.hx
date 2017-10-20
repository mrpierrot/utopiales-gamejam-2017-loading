
package jammer.engines.display.types;

import haxe.Constraints.Function;
import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.Shape;
import flash.events.EventDispatcher;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamBitmap extends JamDisplayObject
{
    public var postRender(get, set) : Function;

    
    
    public var bitmapData : BitmapData;
    public var cache : BitmapData;
    private var _postRender : Function;
    private static var _destPoint : Point = new Point();
    
    
    public function new(pBitmapData : BitmapData)
    {
        bitmapData = pBitmapData;
        super(new FrameData(bitmapData));
        frameData.source = bitmapData.rect.clone();
    }
    
    
    override public function getFrameData(pFrame : Int) : FrameData
    {
        if (_postRender != null)
        {
            //cache.fillRect(cache.rect, 0);
            cache.copyPixels(bitmapData, cache.rect, _destPoint);
            _postRender(cache);
        }
        frameData.destination.x = x;
        frameData.destination.y = y;
        return frameData;
    }
    
    public function setTexture(pMozaic : BitmapData) : Void
    {
        var spr : Sprite = new Sprite();
        var g : Graphics = spr.graphics;
        g.beginBitmapFill(pMozaic, null, true, false);
        g.drawRect(0, 0, bitmapData.width, bitmapData.height);
        g.endFill();
        bitmapData.draw(spr);
    }
    
    
    private function get_postRender() : Function
    {
        return _postRender;
    }
    
    private function set_postRender(value : Function) : Function
    {
        _postRender = value;
        if (_postRender != null)
        {
            if (cache == null)
            {
                cache = bitmapData.clone();
            }
            frameData.asset = cache;
        }
        else
        {
            if (cache != null)
            {
                cache.dispose();
            }
            frameData.asset = bitmapData;
            cache = null;
        }
        return value;
    }
}

