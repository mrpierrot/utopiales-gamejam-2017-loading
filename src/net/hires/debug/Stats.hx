/**
 * stats.as
 * https://github.com/mrdoob/Hi-ReS-Stats
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 * 
 *	addChild( new Stats() );
 *
 **/

package net.hires.debug;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.StyleSheet;
import flash.text.TextField;
import haxe.xml.Fast;

class Stats extends Sprite
{
    
    private var WIDTH : Int = 70;
    private var HEIGHT : Int = 100;
    
    private var xml : Xml;
    
    private var text : TextField;
    private var style : StyleSheet;
    
    private var timer : Int;
    private var fps : Int;
    private var ms : Int;
    private var ms_prev : Int;
    private var mem : Float;
    private var mem_max : Float;
    
    private var graph : BitmapData;
    private var rectangle : Rectangle;
    
    private var fps_graph : Int;
    private var mem_graph : Int;
    private var mem_max_graph : Int;
    
    private var colors : Colors = new Colors();
    
    /**
		 * <b>Stats</b> FPS, MS and MEM, all in one.
		 */
    public function new()
    {
        super();
        
        mem_max = 0;
        
        xml = Xml.parse("<xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>");
        
        style = new StyleSheet();
        style.setStyle("xml", {
                    fontSize : "9px",
                    fontFamily : "_sans",
                    leading : "-2px"
                });
        style.setStyle("fps", {
                    color : hex2css(colors.fps)
                });
        style.setStyle("ms", {
                    color : hex2css(colors.ms)
                });
        style.setStyle("mem", {
                    color : hex2css(colors.mem)
                });
        style.setStyle("memMax", {
                    color : hex2css(colors.memmax)
                });
        
        text = new TextField();
        text.width = WIDTH;
        text.height = 50;
        text.styleSheet = style;
        text.condenseWhite = true;
        text.selectable = false;
        text.mouseEnabled = false;
        
        rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);
        
        addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
    }
    
    private function init(e : Event) : Void
    {
        graphics.beginFill(colors.bg);
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        graphics.endFill();
        
        addChild(text);
        
        graph = new BitmapData(WIDTH, HEIGHT - 50, false, colors.bg);
        graphics.beginBitmapFill(graph, new Matrix(1, 0, 0, 1, 0, 50));
        graphics.drawRect(0, 50, WIDTH, HEIGHT - 50);
        
        addEventListener(MouseEvent.CLICK, onClick);
        addEventListener(Event.ENTER_FRAME, update);
    }
    
    private function destroy(e : Event) : Void
    {
        graphics.clear();
        
        while (numChildren > 0)
        {
            removeChildAt(0);
        }
        
        graph.dispose();
        
        removeEventListener(MouseEvent.CLICK, onClick);
        removeEventListener(Event.ENTER_FRAME, update);
    }
    
    private function update(e : Event) : Void
    {
        timer = Math.round(haxe.Timer.stamp() * 1000);
        
        if (timer - 1000 > ms_prev)
        {
            ms_prev = timer;
            mem = as3hx.Compat.parseFloat((System.totalMemory * 0.000000954).toFixed(3));
            mem_max = (mem_max > mem) ? mem_max : mem;
            
            fps_graph = Math.min(graph.height, (fps / stage.frameRate) * graph.height);
            mem_graph = Std.int(Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2);
            mem_max_graph = Std.int(Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2);
            
            graph.scroll(-1, 0);
            
            graph.fillRect(rectangle, colors.bg);
            graph.setPixel(graph.width - 1, graph.height - fps_graph, colors.fps);
            graph.setPixel(graph.width - 1, graph.height - ((timer - ms) >> 1), colors.ms);
            graph.setPixel(graph.width - 1, graph.height - mem_graph, colors.mem);
            graph.setPixel(graph.width - 1, graph.height - mem_max_graph, colors.memmax);
            
            xml.node.fps.innerData = "FPS: " + fps + " / " + stage.frameRate;
            xml.node.mem.innerData = "MEM: " + mem;
            xml.node.memMax.innerData = "MAX: " + mem_max;
            
            fps = 0;
        }
        
        fps++;
        
        xml.node.ms.innerData = "MS: " + (timer - ms);
        ms = timer;
        
        text.htmlText = xml;
    }
    
    private function onClick(e : MouseEvent) : Void
    {
        (mouseY / height > .5) ? stage.frameRate-- : stage.frameRate++;
        xml.node.fps.innerData = "FPS: " + fps + " / " + stage.frameRate;
        text.htmlText = xml;
    }
    
    // .. Utils
    
    private function hex2css(color : Int) : String
    {
        return "#" + Std.string(color);
    }
}



class Colors
{
    
    public var bg : Int = 0x000033;
    public var fps : Int = 0xffff00;
    public var ms : Int = 0x00ff00;
    public var mem : Int = 0x00ffff;
    public var memmax : Int = 0xff0070;

    public function new()
    {
    }
}