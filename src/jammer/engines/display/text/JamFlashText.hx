package jammer.engines.display.text;

import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import flash.text.TextField;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamFlashText extends JamDisplayObject
{
    public var text : TextField;
    
    public function new(pTextField : TextField = null)
    {
        text = (pTextField != null) ? pTextField : new TextField();
        super(new FrameData(text));
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
        text.transform.matrix = transformMatrix;
    }
}

