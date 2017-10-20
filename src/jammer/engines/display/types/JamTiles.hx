package jammer.engines.display.types;

import haxe.Constraints.Function;
import jammer.engines.display.assets.Asset;
import jammer.engines.display.assets.TileSetAsset;
import jammer.engines.display.FrameData;
import jammer.utils.TilePatternUtils;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamTiles extends JamDisplayObject
{
    
    private static var _uid : Int = 0;
    private var _asset : TileSetAsset;
    private var _tileWidth : Int;
    private var _tileHeight : Int;
    public var bitmap : BitmapData;
    private var _destPoint : Point;
    public var drawTilePattern : TileSetAsset->String->Int->Int->Rectangle;
    
    public function new(pTileSetAsset : TileSetAsset, pTileWidth : Int, pTileHeight : Int, pCols : Int, pRows : Int)
    {
        _asset = pTileSetAsset;
        _tileWidth = pTileWidth;
        _tileHeight = pTileHeight;
        bitmap = new BitmapData(pCols * _tileWidth, pRows * _tileHeight, true, 0);
        _destPoint = new Point();
        super(new FrameData(bitmap));
        frameData.source = bitmap.rect;
        
        drawTilePattern = TilePatternUtils.randomPattern;
    }
    
    public function drawTile(pName : String, pCx : Int, pCy : Int, pDrawTilePattern:TileSetAsset->String->Int->Int->Rectangle=null) : Void
    {
        if (pDrawTilePattern == null)
        {
            pDrawTilePattern = drawTilePattern;
			if (pDrawTilePattern == null) {
				pDrawTilePattern = TilePatternUtils.randomPattern;
			}
        }
        var rect : Rectangle = pDrawTilePattern(_asset, pName, pCx, pCy);
        if (rect != null)
        {
            _destPoint.x = pCx * _tileWidth + (_tileWidth - rect.width) * 0.5;
            _destPoint.y = pCy * _tileHeight + (_tileHeight - rect.height) * 0.5;
            bitmap.copyPixels(_asset.data, rect, _destPoint, null, null, true);
        }
    }
    
    public function apply(pJamTile : JamTiles, pX : Int = 0, pY : Int = 0) : Void
    {
        bitmap.copyPixels(pJamTile.bitmap, pJamTile.bitmap.rect, new Point(pX, pY), null, null, true);
    }
    
    
    public function setTexture(pMozaic : BitmapData) : Void
    {
        var spr : Sprite = new Sprite();
        var g : Graphics = spr.graphics;
        g.beginBitmapFill(pMozaic, null, true, false);
        g.drawRect(0, 0, bitmap.width, bitmap.height);
        g.endFill();
        bitmap.draw(spr);
    }
    
    override public function destruct() : Void
    {
        super.destruct();
        bitmap.dispose();
    }
    
    @:meta(Inline())

    @:final override public function getFrameData(pFrame : Int) : FrameData
    {
        frameData.destination.x = x;
        frameData.destination.y = y;
        return frameData;
    }
}

