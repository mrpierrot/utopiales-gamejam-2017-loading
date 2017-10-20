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

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DialogMessageTheme extends SimpleMessageTheme
{
    
    
    public function new()
    {
        super();
        
        fontName = null;
        fontSize = 8;
        fontColor = 0xFFFFFF;
        backgroundColor = 0x3F4852;
        backgroundAlpha = 1;
        borderColor = 0xFFFFFF;
        borderThickness = 2;
        borderAlpha = 1;
        shadowColor = 0x130A2E;
        shadowDirection = 80;
        shadowDistance = 2;
        padding = 4;
    }
    
    override public function draw(pMessage : Message, pFlatten : Bool) : IBitmapDrawable
    {
        var container : Sprite = new Sprite();
        var g : Graphics = container.graphics;
        var text : DisplayObject = pMessage.content;
        container.addChild(text);
        var x : Int = 0;
        var y : Int = 0;
        var w : Int = Std.int(text.width + padding * 2);
        var h : Int = Std.int(text.height + padding * 2);
        var arrowBase : Int = 5;
        var arrowVertex : Int = 5;
        if (pMessage.position == "bottom")
        {
            y += arrowVertex;
        }
        if (pMessage.position == "right")
        {
            x += arrowVertex;
        }
        text.x = x + padding;
        text.y = y + padding;
        g.clear();
        g.beginFill(backgroundColor, backgroundAlpha);
        g.drawRect(x, y, w, h);
        var _sw0_ = (pMessage.position);        

        switch (_sw0_)
        {
            case "top":
                g.moveTo(Std.int(x + w * 0.5) - arrowBase, y + h);
                g.lineTo(Std.int(x + w * 0.5) + arrowBase, y + h);
                g.lineTo(Std.int(x + w * 0.5), y + h + arrowVertex);
                g.lineTo(Std.int(x + w * 0.5) - arrowBase, y + h);
            case "bottom":
                g.moveTo(Std.int(x + w * 0.5) - arrowBase, y);
                g.lineTo(Std.int(x + w * 0.5) + arrowBase, y);
                g.lineTo(Std.int(x + w * 0.5), y - arrowVertex);
                g.lineTo(Std.int(x + w * 0.5) - arrowBase, y);
            case "right":
                g.moveTo(x, Std.int(y + h * 0.5) - arrowBase);
                g.lineTo(x, Std.int(y + h * 0.5) + arrowBase);
                g.lineTo(x - arrowVertex, Std.int(y + h * 0.5));
                g.lineTo(x, Std.int(y + h * 0.5) - arrowBase);
            case "left":
                g.moveTo(x + w, Std.int(y + h * 0.5) - arrowBase);
                g.lineTo(x + w, Std.int(y + h * 0.5) + arrowBase);
                g.lineTo(x + w + arrowVertex, Std.int(y + h * 0.5));
                g.lineTo(x + w, Std.int(y + h * 0.5) - arrowBase);
        }
        
        g.endFill();
        
        if (pFlatten)
        {
            container.filters = [
                    //new GlowFilter(0x0,0.25, 4,4,4, 1,true),
                    new GlowFilter(borderColor, borderAlpha, borderThickness, borderThickness, borderThickness * 2, 1, true)
            ];
            var bmp : Bitmap = new Bitmap(BitmapUtils.flatten(container));
            bmp.filters = [
                    new DropShadowFilter(2, 80, 0x130A2E, 0.5, 0, 0, 1)
            ];
            return bmp;
        }
        else
        {
            container.filters = [
                    //new GlowFilter(0x0,0.25, 4,4,4, 1,true),
                    new GlowFilter(borderColor, borderAlpha, borderThickness, borderThickness, borderThickness * 2, 1, true), 
                    new DropShadowFilter(shadowDistance, shadowDirection, shadowColor, 0.5, 0, 0, 1)
            ];
        }
        return container;
    }
}

