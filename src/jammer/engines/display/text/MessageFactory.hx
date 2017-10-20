package jammer.engines.display.text;

import haxe.Constraints.Function;
import jammer.Context;
import jammer.engines.display.DepthManager;
import jammer.engines.physics.Entity;
import jammer.process.Process;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class MessageFactory
{
    private var _display : DepthManager;
    public var layer : String;
    
    public static inline var BOX : String = "box";
    public static inline var SIMPLE : String = "simple";
    public static inline var DIALOG : String = "dialog";
    
    public var box : BoxMessageTheme = new BoxMessageTheme();
    public var simple : SimpleMessageTheme = new SimpleMessageTheme();
    public var dialog : DialogMessageTheme = new DialogMessageTheme();
    
    
    private var _themes : Map<String,SimpleMessageTheme>;
    
    public function new(pDisplay : DepthManager, pLayer : String)
    {
        _display = pDisplay;
        layer = pLayer;
        _themes = new Map<String,SimpleMessageTheme>();
        addTheme(BOX, box);
        addTheme(SIMPLE, simple);
        addTheme(DIALOG, dialog);
    }
    
    public function addTheme(pName : String, pTheme : SimpleMessageTheme) : Void
    {
        _themes[pName] = pTheme;
    }
    
    public function create(pText : Dynamic, pX : Dynamic, pY : Dynamic, pTheme : String = "box", pDuration : Int = 90, pCloseCondition : Function = null, pFlatten : Bool = true, pLayer : String = null) : Message
    {
        var message : Message = new Message(pText, pDuration, pCloseCondition);
        message.render(_themes[pTheme], pFlatten);
        var bounds : Rectangle = message.frameData.getBounds();
        var padding : Int = 10;
        if (Std.is(pX, String))
        {
            switch (pX)
            {
                case "center":message.x = Std.int((Context.width - bounds.width) * 0.5);
                case "right":message.x = Std.int(Context.width - bounds.width - padding);
                case "left":message.x = padding;
            }
        }
        else
        {
            message.x = pX;
        }
        if (Std.is(pY, String))
        {
            switch (pY)
            {
                case "center":message.y = Std.int((Context.height - bounds.height) * 0.5);
                case "bottom":message.y = Std.int(Context.height - bounds.height - padding);
                case "top":message.y = padding;
            }
        }
        else
        {
            message.y = pY;
        }
        
        _display.add(message, (pLayer != null) ? pLayer : layer);
        return message;
    }
    
    
    public function say(pEntity : Entity, pText : Dynamic, pTheme : String = "dialog", pPosition : String = "top", pDuration : Int = 90, pCloseCondition : Function = null, pPadding : Int = 10, pFlatten : Bool = true, pLayer : String = null) : Message
    {
        var message : Message = new Message(pText, pDuration, pCloseCondition);
        var xx : Int = pEntity.x;
        var yy : Int = pEntity.y;
        
        message.position = pPosition;
        message.render(_themes[pTheme], true);
        message.noCamera = false;
        
        var process : Process = new Process(0, "Message");
        process.lifeTime = pDuration + Std.int((1 / message.fadeOutSpeed) + 0.5);
        var bounds : Rectangle = message.frameData.getBounds();
        var offsetX : Int = Std.int(-bounds.width * 0.5);
        var offsetY : Int = Std.int(-bounds.height * 0.5);
        switch (pPosition)
        {
            case "top":
                offsetY = Std.int(-bounds.height - pPadding);
            case "bottom":
                offsetY = pPadding;
            case "left":
                offsetX = Std.int(-bounds.width - pPadding);
            case "right":
                offsetX = pPadding;
        }
        process.onRun = function(pDelta : Float = 1) : Void
                {
                    message.x = pEntity.x + offsetX;
                    message.y = pEntity.y + offsetY;
                };
        
        _display.add(message, (pLayer != null) ? pLayer : layer);
        return message;
    }
}

