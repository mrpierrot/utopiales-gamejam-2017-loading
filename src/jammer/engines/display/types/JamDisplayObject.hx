package jammer.engines.display.types;

import jammer.engines.display.DepthManager;
import jammer.engines.display.FrameData;
import flash.display.BlendMode;
import flash.display.StageQuality;
import flash.events.EventDispatcher;
import flash.filters.BitmapFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamDisplayObject extends EventDispatcher
{
    public var globalFramerate(never, set) : Int;

    
    public var x : Int;
    public var y : Int;
    public var centerX : Int;
    public var centerY : Int;
    public var frameData : FrameData;
    public var transformMatrix : Matrix;
    public var transformEnabled : Bool;
    public var transformSmooth : Bool;
    public var color : ColorTransform;
    public var blendMode : BlendMode;
    public var askRemove : Bool;
    public var noCamera : Bool;
    public var cameraSpeedXRate : Float;
    public var cameraSpeedYRate : Float;
    public var visible : Bool;
    public var repeatX : Bool;
    public var repeatY : Bool;
    public var layer : String;
    public var container : DepthManager;
    public var quality : StageQuality;
    
    
    public function new(pFrameData : FrameData = null)
    {
        super();
        frameData = pFrameData;
        transformEnabled = transformSmooth = false;
        centerX = centerY = 0;
        noCamera = false;
        visible = true;
        repeatX = repeatY = false;
        cameraSpeedXRate = cameraSpeedYRate = 1;
    }
    
    private function set_globalFramerate(value : Int) : Int
    {
        return value;
    }
    
    public function clone(pFull : Bool = false) : JamDisplayObject
    {
        return null;
    }
    
    public function destruct() : Void
    {
    }
    
    public function remove() : Void
    {
        if (container != null)
        {
            container.remove(this);
        }
    }
    
    public function getFrameData(pFrame : Int) : FrameData
    {
        return frameData;
    }
    
    public function applyFilter(pFilter : BitmapFilter) : Void
    {
        if (frameData == null)
        {
            return;
        }
        frameData.asset.applyFilter(frameData.asset, frameData.source, frameData.destination, pFilter);
    }
    
    /**
		 * 
		 * @param	pAngle in rad
		 */
    public function rotate(pAngle : Float) : Void
    {
        if (transformMatrix == null)
        {
            transformMatrix = new Matrix();
        }
        transformMatrix.translate(-centerX, -centerY);
        transformMatrix.rotate(pAngle);
        transformMatrix.translate(centerX, centerY);
    }
}

