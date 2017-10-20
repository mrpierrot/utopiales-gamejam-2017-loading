
package jammer.engines.display.types;

import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.Shape;
import flash.events.EventDispatcher;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamFlashSprite extends JamDisplayObject
{
    
    public var sprite : Sprite;
    
    public function new()
    {
        sprite = new Sprite();
        super(new FrameData(sprite));
    }
    
    
    override public function getFrameData(pFrame : Int) : FrameData
    {
        frameData.destination.x = x;
        frameData.destination.y = y;
        return frameData;
    }
    
    
    override public function rotate(pAngle : Float) : Void
    {
        super.rotate(pAngle);
        sprite.transform.matrix = transformMatrix;
    }
}

