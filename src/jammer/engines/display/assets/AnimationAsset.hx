package jammer.engines.display.assets;

import flash.display.BitmapData;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class AnimationAsset extends Asset
{
    
    public var states : Map<String,AnimationState>;
    public var initStateName : String;
    
    
    public function new(pName : String, pData : BitmapData, pStates : Map<String,AnimationState>, pInitStateName : String)
    {
        super(pName, pData);
        states = pStates;
        initStateName = pInitStateName;
    }
    
    override public function clone(pBitmap : Bool = false) : Asset
    {
        return new AnimationAsset(name, (pBitmap) ? data.clone() : data, states, initStateName);
    }
}

