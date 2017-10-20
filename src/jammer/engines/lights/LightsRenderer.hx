package jammer.engines.lights;

import flash.display.BlendMode;
import haxe.Constraints.Function;
import jammer.algo.Bresenham;
import jammer.engines.display.camera.Camera;
import jammer.engines.display.types.JamBitmap;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.utils.ColorUtils;
import jammer.utils.MathUtils;
import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;


typedef LightsRendererConf = {
	var split:Int;
	var darknessColor:UInt;
	var lightDownWall:Bool;
	var postRendering:BitmapData->Rectangle->Point->JamBitmap->Void;
	var floorDistance:Bool;
	var fatLineChecking:Bool;
	var downWallCeilSize:Int;
	var staticLights:Array<LightSource>;
	var dynamicLights:Array<LightSource>;
}

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LightsRenderer extends JamBitmap
{
    public var postRendering : BitmapData->Rectangle->Point->JamBitmap->Void;
    public var postRenderingSource : Rectangle;
    public var postRenderingDestPoint : Point;
    public var level : Level;
    private var _staticLights : Array<LightSource>;
    private var _dynamicLights : Array<LightSource>;
    private var _darknessColor : Int;
    public var lightDownWall : Bool;
    public var rayCanPass : Int->Int->Bool;
    public var lightTile : BitmapData;
    public var lightTileRect : Rectangle;
    private var _destPoint : Point;
    public var halfTile : BitmapData;
    public var halfTileRect : Rectangle;
    public var downWallTile : BitmapData;
    public var downWallTileRect : Rectangle;
    public var downWallCeilSize : Int;
    public var fatLineChecking : Bool;
    public var lineChecking : Function;
    public var skewX : Int;
    public var skewY : Int;
    public var floorDistance : Bool;
    public var buffer : BitmapData;
    public var split : Int;
    private var _firstRender : Bool;
    private var alphaMap : Array<Dynamic>;
    private var otherMap : Array<Dynamic>;
    private var splitTileWidth : Int;
    private var splitTileHeight : Int;
    private var tileWidthRemainder : Int;
    private var tileWidthRemainderInv : Int;
    private var tileHeightRemainder : Int;
    private var tileHeightRemainderInv : Int;
    public var colorGrid : Array<Int>;
    public var staticColorGrid : Array<Int>;
    
    public function new(pBitmap : BitmapData, pLevel : Level, pConf : LightsRendererConf)
    {
        super(pBitmap);
        buffer = pBitmap.clone();
        skewX = skewY = 0;
        split = pConf.split;
        _staticLights = Reflect.hasField(pConf,"staticLights")?pConf.staticLights:null;
        _dynamicLights = Reflect.hasField(pConf,"dynamicLights")?pConf.dynamicLights:null;
        level = pLevel;
        //pDarknessColor:uint = 0xFF383b52, pLightDownWall:Boolean = false,pDownWallCeilSize:int=0
        _darknessColor = Reflect.hasField(pConf,"darknessColor")?pConf.darknessColor:0xFF000000;
        lightDownWall = Reflect.hasField(pConf,"lightDownWall")?pConf.lightDownWall:false;
        postRendering = Reflect.hasField(pConf,"postRendering")?pConf.postRendering:null;
        floorDistance = Reflect.hasField(pConf,"floorDistance")?pConf.floorDistance:false;
        
        _firstRender = true;
        splitTileWidth = Std.int(level.tileWidth / split);
        splitTileHeight = Std.int(level.tileHeight / split);
        tileWidthRemainder = Std.int(level.tileWidth % split);
        tileHeightRemainder = Std.int(level.tileHeight % split);
        tileWidthRemainderInv = Std.int(split - tileWidthRemainder);
        tileHeightRemainderInv = Std.int(split - tileHeightRemainder);
        
        trace(level.tileWidth, level.tileHeight);
        trace(splitTileWidth, splitTileHeight);
        trace(tileWidthRemainder, tileHeightRemainder);
        
        lightTile = new BitmapData(level.tileWidth, level.tileHeight);
        lightTileRect = new Rectangle(0, 0, splitTileWidth, splitTileHeight);
        
        if (lightDownWall)
        {
            downWallCeilSize = Reflect.hasField(pConf,"downWallCeilSize")?pConf.downWallCeilSize:0;
            downWallTile = new BitmapData(level.tileWidth, level.tileHeight - downWallCeilSize);
            downWallTileRect = downWallTile.rect;
        }
        _destPoint = new Point();
        color = new ColorTransform();
        //color.alphaMultiplier = 0.5;
        transformEnabled = true;
        rayCanPass = _rayCanPass;
        fatLineChecking =  pConf.fatLineChecking;
        lineChecking = (fatLineChecking) ? Bresenham.checkFatLine : Bresenham.checkThinLine;
        
        postRenderingSource = buffer.rect.clone();
        postRenderingDestPoint = new Point();
        
        colorGrid = new Array<Int>();
    }
    
    public function renderStatics() : Void
    {
        buffer.fillRect(buffer.rect, _darknessColor);
        if (_staticLights != null)
        {   
            _applyLights(buffer, _staticLights);
        }
    }
    
    public function render() : Void
    {
        if (_firstRender)
        {
            renderStatics();
            staticColorGrid = colorGrid.copy();
            _firstRender = false;
        }
        _destPoint.x = _destPoint.y = 0;
        bitmapData.copyPixels(buffer, buffer.rect, _destPoint, null, null, false);
        
        if (_dynamicLights != null)
        {
            colorGrid = staticColorGrid.copy();
            _applyLights(bitmapData, _dynamicLights);
        }
        
        if (postRendering != null)
        {
            postRendering(bitmapData, postRenderingSource, postRenderingDestPoint, this);
        }
    }
    
    public function applyCamera(pCamera : Camera) : Void
    {
        postRenderingDestPoint.x = postRenderingSource.x = this.x - pCamera.x;
        postRenderingDestPoint.y = postRenderingSource.y = this.y - pCamera.y;
        postRenderingSource.width = pCamera.width;
        postRenderingSource.height = pCamera.height;
    }
    
    public function createDarknessLayer(pMinAlpha : Int = 40, pMaxAlpha : Int = 255, pThreshold : Int = 40, ?pBlendMode : BlendMode) : DarknessLayer
    {
		if (pBlendMode == null) pBlendMode = BlendMode.DARKEN;
        return new DarknessLayer(bitmapData.width, bitmapData.height, pMinAlpha, pMaxAlpha, pThreshold, pBlendMode);
    }
    
    

    private inline function _rayCanPass(pCx : Int, pCy : Int) : Bool
    {
        if (pCy < 0)
        {
            return false;
        }
        if (pCy >= level.rows * split)
        {
            return false;
        }
        if (pCx < 0)
        {
            return false;
        }
        if (pCx >= level.cols * split)
        {
            return false;
        }
        var cell : Cell = level.cells[Std.int(pCy / split) * level.cols + Std.int(pCx / split)];
        if (cell == null)
        {
            return false;
        }
        return !cell.opaque;
    }

    private inline function _applyLights(pBitmap : BitmapData, pLights : Array<LightSource>) : Void
    {
        var points : Array<Dynamic>;
        var light : LightSource;
        var rayPoints : Array<Dynamic>;
        var cell : Cell;
        var xx : Int;
        var yy : Int;
        var lx : Int;
        var ly : Int;
        var i : Int;
        var c : Int;
        var isDownWall : Bool = false;
        var brightness : Float;
        var ldist : Int;
        var xRemainder : Int;
        var yRemainder : Int;
        var xTileBase : Int;
        var yTileBase : Int;
        var gapX : Int;
        var gapY : Int;
        var colorGridIndex : Int;
        var color : Int;
        var colorAlpha : Float;
        
		c = pLights.length;
        for (i in 0...c)
        {
            light = pLights[i];
			lx = Std.int(light.x / level.tileWidth * split);
            ly = Std.int(light.y / level.tileHeight * split);
            
			ldist = Std.int(light.distance * split);
            var dx : Int = -ldist;
            var rx : Int = ldist;
            while (dx <= rx)
            {
                var dy : Int = -ldist;
                var ry : Int = ldist;
                while (dy <= ry)
                {
                    /*if (!postRenderingSource.contains(light.x * level.tileWidth, light.y * level.tileHeight)){
							continue;
						}*/
                    
                    
                    xx = lx + dx;
                    yy = ly + dy;
                    
                    xRemainder = xx % split;
                    yRemainder = yy % split;
                    
                    xTileBase = Std.int(xx / split);
                    yTileBase = Std.int(yy / split);
                    
                    
                    gapX = 0;  //tileWidthRemainder - xRemainder;  ;
                    if (xRemainder > tileWidthRemainderInv)
                    {
                        gapX = xRemainder - tileWidthRemainderInv;
                    }
                    
                    gapY = 0;
                    if (yRemainder > tileHeightRemainderInv)
                    {
                        gapY = yRemainder - tileHeightRemainderInv;
                    }
                    
                    var dist : Float = MathUtils.distance(lx, ly, xx, yy);
                    if (floorDistance)
                    {
                        dist = Std.int(dist);
                    }
                    if (dist <= ldist)
                    {
                        var canDraw : Bool = lineChecking(lx, ly, xx, yy, rayCanPass);
                        //var canDraw:Boolean = lineChecker.checkFatLine(lx, ly, xx, yy);
                        isDownWall = false;
                        if (lightDownWall && ly >= yy && !rayCanPass(xx, yy) && rayCanPass(xx, yy + 1) && lineChecking(lx, ly, xx, yy + 1, rayCanPass))
                        {
                            canDraw = true;
                            isDownWall = true;
                        }
                        if (canDraw)
                        {
                            cell = level.getCell(Std.int(xx / split), Std.int(yy / split));
                            if (cell != null)
                            {
                                brightness = light.intensity * (1 - dist / ldist);
                                colorGridIndex = Std.int(yy * level.cols * split + xx);
                                color = colorGrid[colorGridIndex];
                                //colorAlpha =
                                cell.brightness = MathUtils.fmax(cell.brightness, brightness);
                                if (isDownWall)
                                {
                                    //trace(xRemainder, yRemainder,yy);
                                    if (xRemainder == 0 && yRemainder == split - 1)
                                    {
                                        downWallTileRect.x = xTileBase * level.tileWidth + skewX;
                                        downWallTileRect.y = yTileBase * level.tileHeight + downWallCeilSize + skewY;
                                        colorGrid[colorGridIndex] = ColorUtils.alphaBlend(ColorUtils.addAlphaF(light.color, brightness), color);
                                        pBitmap.fillRect(downWallTileRect, colorGrid[colorGridIndex]);
                                    }
                                }
                                else
                                {
                                    lightTileRect.x = xTileBase * level.tileWidth + xRemainder * splitTileWidth + gapX + skewX;
                                    lightTileRect.y = yTileBase * level.tileHeight + yRemainder * splitTileHeight + gapY + skewY;
                                    lightTileRect.width = splitTileWidth + ((xRemainder >= tileWidthRemainderInv) ? 1 : 0);
                                    lightTileRect.height = splitTileHeight + ((yRemainder >= tileHeightRemainderInv) ? 1 : 0);
                                    colorGrid[colorGridIndex] = ColorUtils.alphaBlend(ColorUtils.addAlphaF(light.color, brightness), color);
                                    pBitmap.fillRect(lightTileRect, colorGrid[colorGridIndex]);
                                }
                            }
                        }
                    }
                    dy++;
                }
                dx++;
            }
        }
    }
	
}

