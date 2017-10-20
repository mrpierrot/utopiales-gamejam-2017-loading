package jammer.engines.display.text;

import jammer.utils.BitmapUtils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class SimpleMessageTheme
{
    
    
    
    public var fontName : String;
    public var fontSize : Int;
    public var fontColor : Int;
    public var backgroundColor : Int;
    public var backgroundAlpha : Float;
    public var borderColor : Int;
    public var borderThickness : Float;
    public var borderAlpha : Float;
    public var shadowColor : Int;
    public var shadowDistance : Int;
    public var shadowDirection : Float;
    public var padding : Int;
    public var position : String;
    public var align : TextFieldAutoSize;
    
    public function new()
    {
        fontName = null;
        fontSize = 8;
        fontColor = 0xFFFFFF;
        backgroundColor = 0x3F4852;
        backgroundAlpha = 1;
        borderColor = 0xFFFFFF;
        borderThickness = 1;
        padding = 2;
        align = TextFieldAutoSize.LEFT;
    }
    
    public function draw(pMessage : Message, pFlatten : Bool) : IBitmapDrawable
    {
        var container : Sprite = new Sprite();
        var g : Graphics = container.graphics;
        var text : DisplayObject = pMessage.content;
        container.addChild(text);
        text.x = text.y = padding;
        g.clear();
        g.beginFill(backgroundColor, 0);
        g.drawRect(0, 0, text.width + padding * 2, text.height + padding * 2);
        g.endFill();
        
        if (pFlatten)
        {
            var bmp : Bitmap = new Bitmap(BitmapUtils.flatten(container));
            bmp.filters = [
                    new GlowFilter(0x0, 1, 2, 2, 4, 1, false)
            ];
            return bmp;
        }
        else
        {
            container.filters = [
                    new GlowFilter(0x0, 1, 2, 2, 4, 1, false)
            ];
        }
        return container;
    }
}

