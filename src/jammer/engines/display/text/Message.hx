package jammer.engines.display.text;

import haxe.Constraints.Function;
import jammer.Context;
import jammer.engines.display.assets.AssetsManager;
import jammer.engines.display.FrameData;
import jammer.engines.display.types.JamDisplayObject;
import jammer.engines.display.types.JamFlashSprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFormat;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Message extends JamDisplayObject
{
    
    public var textField : TextField;
    public var content : DisplayObject;
    public var duration : Int;
    public var fadeInSpeed : Float;
    public var fadeOutSpeed : Float;
    public var alpha : Float;
    public var closeCondition : Function;
    public var position : String;
    private var _text : String;
    
    public function new(pText : Dynamic, pDuration : Int = 90, pCloseCondition : Function = null)
    {
        if (Std.is(pText, String))
        {
            _text = pText;
        }
        else
        {
            if (Std.is(pText, DisplayObject))
            {
                content = pText;
            }
            else
            {
                if (Std.is(pText, BitmapData))
                {
                    content = new Bitmap(pText);
                }
            }
        }
        
        duration = pDuration;
        closeCondition = pCloseCondition;
        
        
        
        super();
        
        
        fadeInSpeed = 0.2;
        fadeOutSpeed = 0.05;
        alpha = 0;
        color = new ColorTransform();
        transformEnabled = true;
        noCamera = true;
    }
    
    public function render(pTheme : SimpleMessageTheme, pFlatten : Bool = true) : Void
    {
        if (_text != null)
        {
            if (textField == null)
            {
                textField = AssetsManager.instance.createFlashText(_text, pTheme.fontSize, pTheme.fontColor, pTheme.fontName, pTheme.align);
                textField.addEventListener(Event.CHANGE, function(e : Event) : Void
                        {
                            render(pTheme, pFlatten);
                        });
            }
            else
            {
                var format : TextFormat = textField.defaultTextFormat;
                format.font = pTheme.fontName;
                format.color = pTheme.fontColor;
                format.size = pTheme.fontSize;
                textField.autoSize = pTheme.align;
                textField.defaultTextFormat = format;
                textField.setTextFormat(format);
            }
            content = textField;
        }
        if (frameData == null)
        {
            frameData = new FrameData(pTheme.draw(this, pFlatten));
        }
        else
        {
            var result : IBitmapDrawable = pTheme.draw(this, pFlatten);
            if (Std.is(result, BitmapData))
            {
                frameData.drawable = null;
                frameData.asset = cast((pTheme.draw(this, pFlatten)), BitmapData);
            }
            else
            {
                frameData.asset = null;
                frameData.source = null;
                frameData.drawable = cast((pTheme.draw(this, pFlatten)), DisplayObject);
            }
        }
        if (frameData.asset != null)
        {
            frameData.source = frameData.asset.rect;
        }
        if (frameData.drawable != null)
        {
            frameData.source = frameData.drawable.getBounds(frameData.drawable);
        }
    }
    
    override public function getFrameData(pFrame : Int) : FrameData
    {
        // Fade in
        if (duration != 0 && fadeInSpeed != 0)
        {
            alpha += fadeInSpeed;
            if (alpha > 1)
            {
                alpha = 1;
            }
        }
        if (closeCondition != null && closeCondition())
        {
            duration = 0;
        }
        if (duration >= 0)
        {
            duration--;
            if (duration < 0)
            {
                duration = 0;
            }
            
            // Fade out (life)
            if (duration == 0)
            {
                alpha -= fadeOutSpeed;
                if (alpha < 0)
                {
                    alpha = 0;
                }
            }
            if (duration == 0 && alpha <= 0)
            {
                askRemove = true;
            }
        }
        
        color.alphaMultiplier = alpha;
        frameData.destination.x = x;
        frameData.destination.y = y;
        return frameData;
    }
    
    public static function create(pText : String, pX : Int, pY : Int, pDuration : Int = 90, pCloseCondition : Function = null, pTheme : BoxMessageTheme = null, pFlatten : Bool = true) : Message
    {
        var msg : Message = new Message(pText, pDuration, pCloseCondition);
        msg.x = pX;
        msg.y = pY;
        msg.render(pTheme, pFlatten);
        return msg;
    }
    
    override public function destruct() : Void
    {
        if (frameData.asset != null)
        {
            frameData.asset.dispose();
        }
        if (frameData.drawable != null && Std.is(frameData.drawable, Bitmap))
        {
            cast((frameData.drawable), Bitmap).bitmapData.dispose();
        }
    }
}

