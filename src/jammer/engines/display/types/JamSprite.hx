package jammer.engines.display.types;

import jammer.engines.display.assets.Asset;
import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import flash.events.EventDispatcher;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamSprite extends JamDisplayObject
{
    
    private var _asset : Asset;
    
    
    public function new(pAsset : Asset)
    {
        _asset = pAsset;
        super(new FrameData(_asset.data));
        if (_asset.source!=null)
        {
            frameData.source = _asset.source.clone();
        }
        else
        {
            frameData.source.width = _asset.data.width;
            frameData.source.height = _asset.data.height;
        }
    }
    
    override public function clone(pFull : Bool = false) : JamDisplayObject
    {
        return new JamSprite((pFull) ? _asset.clone(pFull) : _asset);
    }
    
    
    @:meta(Inline())

    @:final override public function getFrameData(pFrame : Int) : FrameData
    {
        frameData.destination.x = x;
        frameData.destination.y = y;
        return frameData;
    }
}

