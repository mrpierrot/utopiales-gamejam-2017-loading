package jammer.debug;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.Dictionary;
import haxe.xml.Fast;



/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DebugInfos extends Sprite
{
    
    private static var _me : DebugInfos;
    
    private var _xml : Fast;
    private var _style : StyleSheet;
    private var _text : TextField;
    private var _width : Float;
    private var _map : Dictionary;
    
    public function new(pWidth : Float = 90)
    {
        super();
        _me = this;
        _width = pWidth;
        _xml = FastXML.parse("<lines></lines>");
        _style = new StyleSheet();
        _style.setStyle("lines", {
                    fontSize : "9px",
                    fontFamily : "_sans",
                    leading : "-2px"
                });
        _style.setStyle("line", {
                    display : "block"
                });
        _style.setStyle("label", {
                    color : "#00ff00",
                    display : "inline"
                });
        _style.setStyle("value", {
                    color : "#ffff00",
                    display : "inline"
                });
        
        _text = new TextField();
        _text.width = _width;
        _text.styleSheet = _style;
        _text.condenseWhite = true;
        _text.selectable = false;
        _text.autoSize = TextFieldAutoSize.LEFT;
        _text.mouseEnabled = false;
        _text.background = true;
        _text.backgroundColor = 0x1A1A1A;
        x = 0;
        this.addChild(_text);
        
        _map = new Dictionary();
        
        this.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
    }
    
    private function _enterFrameHandler(e : Event) : Void
    {
        _text.htmlText = _xml;
        y = this.stage.stageHeight - this.height;
    }
    
    
    
    
    public static function createLine(pId : String, pLabel : String = null, pRest : Array<Dynamic> = null) : Void
    {
        if (_me == null)
        {
            return;
        }
        _me._map[pId] = true;
        _me._xml.appendChild(FastXML.parse("<line id=\"" + pId + "\"><label>" + ((pLabel != null) ? pLabel : pId) + " : </label><value>" + pRest.join(" , ") + "</value></line>"));
    }
    
    
    public static function updateLine(pId : String, pRest : Array<Dynamic> = null) : Void
    {
        if (_me == null)
        {
            return;
        }
        if (!_me._map.exists(pId))
        {
            createLine(pId, pId);
        }
    }
}

