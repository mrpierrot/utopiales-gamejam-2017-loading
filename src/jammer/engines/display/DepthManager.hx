package jammer.engines.display;

import flash.errors.Error;
import jammer.engines.display.types.JamDisplayObject;
import flash.display.Sprite;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DepthManager
{
    public var children(get, never) : Array<JamDisplayObject>;

    
    private var _layers : Map<String,JamDisplayObject>;
    private var _children : Array<JamDisplayObject>;
    
    public function new()
    {
        _children = new Array<JamDisplayObject>();
        _layers = new Map<String,JamDisplayObject>();
        createLayer("default");
    }
    
    public function createLayer(pName : String, pChildren : Array<Dynamic> = null, pBefore : String = null) : Void
    {
        if (pName == null)
        {
            throw new Error("Layer name canot be null");
        }
        var layer : Layer = new Layer(pName);
        _layers[pName] = layer;
        if (pBefore == null)
        {
            _children.push(layer);
        }
        else
        {
			
            var index : Int = _getLayerIndex(pBefore);
            if (index == 0)
            {
				_children.insert(index, layer);
            }
            else
            {
                index--;
                while (index >= 0)
                {
                    if (Std.is(_children[index], Layer))
                    {
						_children.insert(index + 1, layer);
						break;
                    }
                    index--;
                }
            }
        }
        if (pChildren != null)
        {
            var i : Int = 0;
            var c : Int = pChildren.length;
            while (i < c)
            {
                add(pChildren[i], pName);
                i++;
            }
        }
    }
    
    @:meta(Inline())

    @:final private function _getLayerIndex(pName : String) : Int
    {
        if (!_layers.exists(pName))
        {
            throw new Error("Layer " + pName + " not found");
        }
        return Lambda.indexOf(_children, _layers[pName]);
    }
    
    public function add(pSprite : JamDisplayObject, pLayer : String="default") : Void
    {

        if (!_layers.exists(pLayer))
        {
            throw new Error("Layer " + pLayer + " not found");
        }
        var layer : Layer = cast(_layers[pLayer],Layer);
		_children.insert(Lambda.indexOf(_children, layer), pSprite);
        layer.size++;
        pSprite.layer = pLayer;
        pSprite.container = this;
    }
    
    public function remove(pSprite : JamDisplayObject) : Void
    {
        var index : Int = Lambda.indexOf(_children, pSprite);
        if (index >= 0)
        {
			
            _children.splice(index, 1);
			var layer : Layer = cast(_layers[pSprite.layer],Layer);
            layer.size--;
            pSprite.layer = null;
            pSprite.container = null;
        }
    }
    
    public function clearLayer(pName : String) : Void
    {
        var index : Int = _getLayerIndex(pName);
        var obj : JamDisplayObject;
		var layer : Layer = cast(_layers[pName],Layer);
        var size : Int = layer.size;
        if (size > 0 && index >= 0)
        {
            for (i in 1...size)
            {
                obj = _children[index - i];
                trace(obj);
                obj.layer = null;
                obj.container = null;
            }
            _children.splice(index - size, size);
            layer.size = 0;
        }
    }
    
    /**
		 * Y-Sorting of movieclips in a plan
		 */
    @:meta(Inline())

    @:final public function ysort(pLayer : String) : Void
    {
        if (!_layers.exists(pLayer))
        {
            throw new Error("Layer " + pLayer + " not found");
        }
        var layer : Layer = cast(_layers[pLayer],Layer);
        var y : Float = -99999999;
        var last : Int = Lambda.indexOf(_children, layer);
        var start : Int = last - layer.size;
        
        for (i in start...last)
        {
            var mc : JamDisplayObject = _children[i];
            if (mc.y >= y)
            {
                y = mc.y;
            }
            else
            {
                var j : Int = i - 1;
                while (j >= start)
                {
                    var mc2 : JamDisplayObject = _children[j];
                    if (mc2.y <= mc.y)
                    {
                        break;
                    }
                    j--;
                }
                //root.addChildAt(mc,j+1);
                _children.splice(i, 1);
				_children.insert(j + 1, mc);
            }
        }
    }
    
    @:meta(Inline())

    @:final private function get_children() : Array<JamDisplayObject>
    {
        return _children;
    }
}

