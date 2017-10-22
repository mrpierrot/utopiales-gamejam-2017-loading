package jammer.engines.level.parsers;

import haxe.Constraints.Function;
import jammer.engines.display.assets.TileSetAsset;
import jammer.engines.display.types.JamTiles;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import jammer.utils.ObjectUtils;
import flash.display.Bitmap;
import flash.display.BitmapData;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LevelBitmapParser
{
    
	
	public static function parse(pSource:BitmapData, pTileWidth : Int, pTileHeight : Int, pConf:Map<UInt,Array<String>>):Level {
		var level : Level = new Level(pSource.width, pSource.height, pTileWidth, pTileHeight);
		var color:UInt;
		for (x in 0...level.cols) {
			for (y in 0...level.rows) {
				color = pSource.getPixel(x, y);
				if (pConf.exists(color)) {
					level.getCell(x, y).addMarkers(pConf[color]);
				}
			}
		}
		return level;
	}

    public function new()
    {
    }
}

