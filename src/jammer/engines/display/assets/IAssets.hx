package jammer.engines.display.assets;
import flash.display.BitmapData;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
interface IAssets
{
	function getSprites() : Map<String,Class<BitmapData>>
    ;
    function getAnimations() : Dynamic
    ;
    function getSpriteSheets() : Dynamic
    ;
    function getTileSets() : Dynamic
    ;
}

