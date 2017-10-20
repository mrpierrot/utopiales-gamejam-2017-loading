package jammer.utils;

import jammer.engines.display.assets.TileSetAsset;
import jammer.engines.display.types.JamTiles;
import jammer.engines.level.Cell;
import jammer.engines.level.Level;
import flash.geom.Rectangle;
import flash.utils.Function;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class LevelUtils
{
    
    public function new()
    {
    }
    
    /**
		 * 
		 * 
			const markers:* = [
				 {
					selector:"floor default",
					layers:{
						"floor": { fill:"slabs", pattern:TilePatternUtils.createWeightRandomPattern(Vector.<Number>([10, 5, 2, 0.5])) }
					}
				},{
					selector:"floor clay",
					layers:{
						"floor": { fill:"clay", pattern:TilePatternUtils.createWeightRandomPattern(Vector.<Number>([5, 5, 5, 5])) }
					}
				},{	
					selector:"wall",
					opaque:true,
					layers: {
						"walls":{ fill:"fill", down:"down" }
					}
				},{	
					selector:"light",
					render: function(pcell:Cell):void {
						
					},
					layers: {
						"lights": "light"
					}
				},{	
					selector:"",
					opaque:true,
					"default":true,
					layers: {
						"over":{ fill:"blackFill", down:"empty" }
					}
				}
			];
			
		 * @param	pLevel
		 * @param	pConf
		 */
    
    public static function renderLevel(pLevel : Level, pLayersConf : Array<Dynamic>, pMarkersConf : Array<MarkerConf>) : Void
    {
        var layersConf : Dynamic = pLayersConf;
        var markersConf : Dynamic = pMarkersConf;
        
        for (layerConf in pLayersConf)
        {
            pLevel.createLayer(layerConf.name, layerConf.assets);
        }
        
        var defaultConf : MarkerConf = null;
        for (aConf in pMarkersConf)
        {
            if (aConf.defaultMarker)
            {
                defaultConf = aConf;
                break;
            }
        }
		
		trace(defaultConf);
        
        var cell : Cell;
        var haveRender : Bool;
        var i : Int = pLevel.cells.length-1;
        //var c : Int = pLevel.cells.length;
        while (i >=0)
        {
            cell = pLevel.cells[i];
            haveRender = false;
            //trace(i+" / "+c);
            for (conf/* AS3HX WARNING could not determine type for var: conf exp: ECall(EIdent(getCellConfs),[EIdent(cell),EIdent(pMarkersConf)]) type: null */ in getCellConfs(cell, pMarkersConf))
            {
                //jam_log(conf);
                if (renderCell(conf, cell))
                {
                    haveRender = true;
                }
            }
            if (!haveRender)
            {
                renderCell(defaultConf, cell);
            }
            i--;
        }
    }
    
    
    
    public static function renderCell(pConf : MarkerConf, pCell : Cell) : Bool
    {
        var markerConf : MarkerConf = pConf;
        if (Reflect.hasField(markerConf,"opaque"))
        {
            pCell.opaque = markerConf.opaque;
        }
		if (Reflect.hasField(markerConf,"collide"))
        {
            pCell.collide = markerConf.collide;
        }
		if (Reflect.hasField(markerConf,"render"))
        {
            markerConf.render(pCell);
        }
        if (markerConf.layers != null)
        {
            var layerConf : LayerConf;
            var jamTiles : JamTiles;
            var aCell : Cell;
            for (name in markerConf.layers.keys())
            {
                jamTiles = pCell.level.getLayerByName(name);
                layerConf = markerConf.layers[name];
                
				if (layerConf.down != null && layerConf.fill != null)
				{
					if (pCell.cy + 1 < pCell.level.rows)
					{
						aCell = pCell.level.getCell(pCell.cx, pCell.cy + 1);
						if (!aCell.collide)
						{
							jamTiles.drawTile(layerConf.down, pCell.cx, pCell.cy,layerConf.pattern);
						}
						else
						{
							jamTiles.drawTile(layerConf.fill, pCell.cx, pCell.cy,layerConf.pattern);
						}
					}
					else
					{
						jamTiles.drawTile(layerConf.fill, pCell.cx, pCell.cy,layerConf.pattern);
					}
				}
				else
				{
					if (layerConf.fill != null)
					{
						jamTiles.drawTile(layerConf.fill, pCell.cx, pCell.cy,layerConf.pattern);
					}
				}
                
            }
        }
        return true;
    }
    
    public static function getCellConfs(pCell : Cell, pConf : Array<Dynamic>) : Array<Dynamic>
    {
        return pConf.filter(function(obj : Dynamic) : Bool
                {
                    var selectors : Array<Dynamic> = obj.selector.split(' ');
                    
                    for (selector in selectors)
                    {
                        if (selector.length > 0 && selector.charAt(0) == "!")
                        {
                            if (pCell.haveMarker(selector.substr(1)))
                            {
                                return false;
                            }
                        }
                        else
                        {
                            if (!pCell.haveMarker(selector))
                            {
                                return false;
                            }
                        }
                    }
                    return true;
                });
    }
}

typedef MarkerConf = {
	var selector:String;
	@:optional var opaque:Bool;
	@:optional var collide:Bool;
	@:optional var defaultMarker:Bool;
	@:optional var render:Cell->Void;
	var layers:Map<String,LayerConf>;
}

typedef LayerConf = {
	var fill:String;
	@:optional var down:String;
	@:optional var pattern:TileSetAsset->String->Int->Int->Rectangle;
}

/*
@:struct class MarkerConf {
	public var selector:String;
	public var opaque:Bool;
	public var defaultMarker:Bool;
	public var layers:Map<String,LayerConf>;

	public inline function new(
		selector,
		?opaque = false,
		?defaultMarker = false,
		?layers = null
	) {
	  this.selector = selector;
	  this.opaque = opaque;
	  this.defaultMarker = defaultMarker;
	  this.layers = layers;
	}
}

@:struct class LayerConf {
	public var fill:String;
	public var down:String;
	public var pattern:Function->TileSetAsset->String->Int->Int->Rectangle;
	
	public inline function new(
		fill,
		?down = null,
		?pattern = null
		
	) {
	  this.fill = fill;
	  this.down = down;
	  this.pattern = pattern;
	 
	}
}*/