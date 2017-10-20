package jammer.engines.lights;

import jammer.algo.Bresenham;
import jammer.engines.display.types.JamBitmap;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.utils.ColorUtils;
import jammer.utils.MathUtils;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LightsContainer extends LightsRenderer
{
    
    
    public function new(pLevel : Level, pConf : Dynamic)
    {
        super(new BitmapData(pLevel.cols * pLevel.tileWidth, pLevel.rows * pLevel.tileHeight, true, pConf.darknessColor), pLevel, pConf);
    }
}





