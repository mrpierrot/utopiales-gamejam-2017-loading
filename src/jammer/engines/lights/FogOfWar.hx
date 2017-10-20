package jammer.engines.lights;

import haxe.Constraints.Function;
import jammer.algo.Bresenham;
import jammer.engines.display.types.JamBitmap;
import jammer.engines.level.Level;
import jammer.utils.ColorUtils;
import jammer.utils.MathUtils;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class FogOfWar extends JamBitmap
{
    private var _level : Level;
    private var _tileRect : Rectangle;
    private var _darknessColor : Int;
    private var _buffer : BitmapData;
    private var _destPoint : Point;
    public var rayCanPass : Int->Int->Bool;
    public var postFilter : BitmapFilter;
    public var eraseMode : Bool;
    public var intensity : Float;
    public var postRendering : Function;
    
    public function new(pLevel : Level, pDarknessColor : Int = 0xFF000000, pEraseMode : Bool = true, pIntensity : Float = 1)
    {
        _level = pLevel;
        _darknessColor = pDarknessColor;
        postFilter = new BlurFilter(_level.tileWidth, _level.tileHeight);
        super(new BitmapData(_level.cols * _level.tileWidth, _level.rows * _level.tileHeight, true, 0));
        _buffer = new BitmapData(_level.cols * _level.tileWidth, _level.rows * _level.tileHeight, true, _darknessColor);
        _tileRect = new Rectangle(0, 0, _level.tileWidth, _level.tileHeight);
        _destPoint = new Point();
        rayCanPass = _rayCanPass;
        eraseMode = pEraseMode;
        intensity = pIntensity;
    }
    
    
    public function reveal(pCx : Int, pCy : Int, pRadius : Int) : Bool
    {
        if (!eraseMode)
        {
            _buffer.fillRect(_buffer.rect, _darknessColor);
        }
        //pRadius = 0;
        var updated : Bool = false;
        var xx : Int;
        var yy : Int;
        var color : Int;
        var alpha : Int;
        var dx : Int = -pRadius;
        var rx : Int = pRadius;
        while (dx <= rx)
        {
            var dy : Int = -pRadius;
            var ry : Int = pRadius;
            while (dy <= ry)
            {
                xx = Std.int(pCx + dx);
                yy = Std.int(pCy + dy);
                var dist : Float = MathUtils.squareDistance(pCx, pCy, xx, yy);
                if (xx < 0)
                {
                    {dy++;continue;
                    }
                }
                if (xx >= _level.cols)
                {
                    {dy++;continue;
                    }
                }
                if (yy < 0)
                {
                    {dy++;continue;
                    }
                }
                if (yy >= _level.rows)
                {
                    {dy++;continue;
                    }
                }
                if (dist <= pRadius * pRadius && Bresenham.checkFatOuterLine(pCx, pCy, xx, yy, rayCanPass))
                {
                    _tileRect.x = xx * _level.tileWidth;
                    _tileRect.y = yy * _level.tileHeight;
                    // calcul l'alpha que l'on souhaite pour le tile courant
                    alpha = Std.int(0xFF * (dist / (pRadius * pRadius)) * intensity);
                    // si l'alpha de la tile est à inférieur à la nouvel alpha alors on passe le tile courant
                    if (!eraseMode || Std.int((1 - _level.getCell(xx, yy).discovered) * 255) > alpha)
                    {
                        color = _darknessColor & 0x00FFFFFF;
                        color = Std.int(alpha << 24) | color;
                        _buffer.fillRect(_tileRect, color);
                        _level.getCell(xx, yy).discovered = 1 - alpha / 255;
                        updated = true;
                    }
                }
                dy++;
            }
            dx++;
        }
        if (updated)
        {
            if (postFilter != null)
            {
                bitmapData.applyFilter(_buffer, _buffer.rect, _destPoint, postFilter);
            }
            else
            {
                bitmapData.copyPixels(_buffer, _buffer.rect, _destPoint, _buffer);
            }
            if (postRendering != null)
            {
                postRendering(bitmapData, this);
            }
        }
        return updated;
    }
    
    @:meta(Inline())

    @:final private function _rayCanPass(pCx : Int, pCy : Int) : Bool
    {
        return !_level.hasCollision(pCx, pCy);
    }
}

