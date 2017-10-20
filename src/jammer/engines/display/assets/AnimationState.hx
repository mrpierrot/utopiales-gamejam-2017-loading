package jammer.engines.display.assets;

import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class AnimationState
{
    
    public var name : String;
    public var frames : Array<Rectangle>;
    public var framerate : Int;
	public var cues:Map<Int,String>;
    
    public function new(pName : String, pFrames : Array<Rectangle>, pFramerate : Int,pCues:Map<Int,String>)
    {
        name = pName;
        frames = pFrames;
        framerate = pFramerate;
		cues = pCues;
    }
    
    public function toString() : String
    {
        return "[AnimationState name=" + name + " frames=" + frames + " framerate=" + framerate + "]";
    }
}

