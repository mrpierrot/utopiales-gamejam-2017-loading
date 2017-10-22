package loading;

import jammer.engines.display.text.Message;
import jammer.engines.display.text.SimpleMessageTheme;
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
class HBoxMessageTheme extends SimpleMessageTheme
{
    
    
    public function new()
    {
        super();
        
        fontName = null;
        fontSize = 8;
        fontColor = 0x5f0a4c;
        backgroundColor = 0xbdaca8;
        backgroundAlpha = 1;
        borderColor = 0x1b191b;
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
        text.x = text.y = padding;
        g.clear();
        g.beginFill(backgroundColor, backgroundAlpha);
        g.drawRect(0, 0, text.width + padding * 2, text.height + padding * 2);
        g.endFill();
        
        
        if (pFlatten)
        {
            container.filters = [
                    new GlowFilter(0x0, 0.25, 4, 4, 4, 1, true), 
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
                    new GlowFilter(0x0, 0.25, 4, 4, 4, 1, true), 
                    new GlowFilter(borderColor, borderAlpha, borderThickness, borderThickness, borderThickness * 2, 1, true), 
                    new DropShadowFilter(shadowDistance, shadowDirection, shadowColor, 0.5, 0, 0, 1)
            ];
        }
        return container;
    }
}

