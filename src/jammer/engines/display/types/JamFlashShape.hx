
package jammer.engines.display.types;

import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.Shape;
import flash.events.EventDispatcher;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamFlashShape extends JamDisplayObject
{
    public var original(get, never) : Shape;
    public var graphics(get, never) : Graphics;

    
    private var _original : Shape;
    private var _graphics : Graphics;
    
    
    
    public function new()
    {
        _original = new Shape();
        _graphics = _original.graphics;
        super(new FrameData(_original));
    }
    
    
    override public function getFrameData(pFrame : Int) : FrameData
    {
        frameData.destination.x = x;
        frameData.destination.y = y;
        return frameData;
    }
    
    
    private function get_original() : Shape
    {
        return _original;
    }
    
    private function get_graphics() : Graphics
    {
        return _graphics;
    }
    
    
    override public function rotate(pAngle : Float) : Void
    {
        super.rotate(pAngle);
        _original.transform.matrix = transformMatrix;
    }
}

