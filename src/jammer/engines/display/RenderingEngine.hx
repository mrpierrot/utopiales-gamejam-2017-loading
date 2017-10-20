package jammer.engines.display;

import jammer.engines.display.types.JamDisplayObject;
import flash.display.BitmapData;
import flash.display.Sprite;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class RenderingEngine extends DepthManager
{
    public var buffer : Buffer;
    private var _framerate : Int;
    
    public function new(pWidth : Int, pHeight : Int, pFramerate : Int = 30, pScale : Float = 1, pColor : Int = 0xFF000000)
    {
        super();
        _framerate = pFramerate;
        buffer = new Buffer(pWidth, pHeight, this, pScale, pColor);
    }
    
    override public function add(pSprite : JamDisplayObject, pLayer : String = null) : Void
    {
        pSprite.globalFramerate = _framerate;
        super.add(pSprite, pLayer);
    }
}

