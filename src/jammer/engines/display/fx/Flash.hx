package jammer.engines.display.fx;

import flash.geom.ColorTransform;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Flash
{
    
    private var _colorTransform : ColorTransform;
    private var _value : Float;
    public var flashValue : Float;
    public var flashFriction : Float;
    public function new(pColorTransform : ColorTransform, pFlashValue : Float = 0.8, pFlashFriction : Float = 0.8)
    {
        _colorTransform = pColorTransform;
        flashValue = pFlashValue;
        flashFriction = pFlashFriction;
        _value = 0;
    }
    
    @:meta(Inline())

    @:final public function start() : Void
    {
        _value = flashValue;
    }
    
    @:meta(Inline())

    @:final public function update() : Void
    {
        if (_value > 0)
        {
            _value *= flashFriction;
            if (_value < 0.01)
            {
                _value = 0;
            }
            _colorTransform.redOffset = _value * 0xFF;
            _colorTransform.greenOffset = _value * 0xFF;
            _colorTransform.blueOffset = _value * 0xFF;
        }
    }
}

