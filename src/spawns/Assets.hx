package spawns;

import jammer.engines.display.assets.IAssets;
import flash.display.BitmapData;

@:bitmap("src/assets/tiles-32x26.png") class Tiles extends BitmapData { }
@:bitmap("src/assets/human-32.png") class Human extends BitmapData { }
@:bitmap("src/assets/human-halo-32.png") class HumanHalo extends BitmapData { }
@:bitmap("src/assets/cube-32.png") class Slim extends BitmapData { }
@:bitmap("src/assets/level.png") class DemoLevel extends BitmapData { }

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Assets implements IAssets
{
    
    public static inline var TILE_SIZE : Int = 32;
    
    public function new()
    {
    }
	
	public function getSprites():Map<String, Class<BitmapData>> 
	{
		return [
			"level" => DemoLevel,
			"halo" => HumanHalo,
			
		];
	}
    
    
    public function getAnimations() : Dynamic
    {
		
        
        
        return {
			cube: {
				asset:Slim, 
				framerate:6,
				initState:"staticDown",
				states: { 
					"staticDown": { frames:"1", width:TILE_SIZE, height:TILE_SIZE },
					"staticUp": { frames:"8", width:TILE_SIZE, height:TILE_SIZE },
					"staticRight": { frames:"1", width:TILE_SIZE, height:TILE_SIZE },
					"staticLeft":{ frames:"8", width:TILE_SIZE, height:TILE_SIZE },
					"runDown":{ frames:"0:3", width:TILE_SIZE, height:TILE_SIZE },
					"runUp":{ frames:"9:6", width:TILE_SIZE, height:TILE_SIZE },
					"runRight":{ frames:"0:3", width:TILE_SIZE, height:TILE_SIZE },
					"runLeft": { frames:"9:6", width:TILE_SIZE, height:TILE_SIZE },
					"jumpRight":{ frames:"0", width:TILE_SIZE, height:TILE_SIZE },
					"jumpLeft": { frames:"0", width:TILE_SIZE, height:TILE_SIZE },
					"debug":{ frames:"0", width:TILE_SIZE, height:TILE_SIZE }
				}
			},
            human : {
                asset : Human,
                framerate : 12,
                initState : "staticDown",
                states : {
                    staticDown : {
                        frames : {
                            x : 2,
                            y : 1
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    staticUp : {
                        frames : {
                            x : 2,
                            y : 3
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    staticRight : {
                        frames : {
                            x : 2,
                            y : 2
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    staticLeft : {
                        frames : {
                            x : 2,
                            y : 4
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    runDown : {
                        frames : {
                            x : "1:4",
                            y : 1
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    runUp : {
                        frames : {
                            x : "1:4",
                            y : 3
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    runRight : {
                        frames : {
                            x : "1:4",
                            y : 2
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    },
                    runLeft : {
                        frames : {
                            x : "1:4",
                            y : 4
                        },
                        width : TILE_SIZE,
                        height : TILE_SIZE
                    }
                }
            }
        };
    }
    
    public function getTileSets() : Dynamic
    {
      
        
        return {
            floors : {
                asset : Tiles,
                formats : [
                {
                    startY : 0,
                    tileWidth : TILE_SIZE,
                    tileHeight : 26,
                    placements : {
                        floor : "0:1",
                        blackFill : "4",
                        blackDown : "5",
                        clay : "6:9",
                        light : "10",
                        grid : "11:12",
                        empty : "15",
                        "wall-down" : "17:19",
                        "wall-fill" : "20:22",
                        "wall-down-over" : "3",
                        "door-down" : "23",
                        "slabs-45" : "24",
                        rock : "25:27",
                        "block-wall-down" : {
                            x : "6:8",
                            y : 4
                        },
                        slabs : {
                            x : "6:8",
                            y : "5:6"
                        },
                        "clay-2" : {
                            x : "1:5",
                            y : "5:6"
                        },
                        wood : {
                            x : "1:4",
                            y : 7
                        }
                    }
                }
        ]
            }
        };
    }
    
    
    public function getSpriteSheets() : Dynamic
    {
        return { };
    }

	
	
}

