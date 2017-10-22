package loading;

import jammer.engines.display.assets.IAssets;
import flash.display.BitmapData;

@:bitmap("src/assets/workbench1.png") class WorkbenchSprite extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheet.png") class HamsterSprite extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheetContour.png") class HaloSprite extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheetShock.png") class ShockSprite extends BitmapData { }
@:bitmap("src/assets/wallGround1.png") class Tiles extends BitmapData { }
@:bitmap("src/assets/level.png") class DemoLevel extends BitmapData { }

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Assets implements IAssets
{
    
    public static inline var TILE_WIDTH : Int = 32;
    public static inline var TILE_HEIGHT : Int = 26;
	public static inline var FPS : Int = 30;
    
    public function new()
    {
    }
	
	public function getSprites():Map<String, Class<BitmapData>> 
	{
		return [
			"level" => DemoLevel,
			"workbench" => WorkbenchSprite,
			"halo" => HaloSprite,
			"shocked" => ShockSprite
		];
	}
    
    
    public function getAnimations() : Dynamic
    {
		
        return {
            hamster : {
                asset : HamsterSprite,
                framerate : 8,
                initState : "idle",
                states : {
               
                    runRight : {
                        frames : {
                            x : "1:4",
                            y : 2
                        },
						framerate:8,
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT
                    },
                    runLeft : {
                        frames : {
                            x : "1:4",
                            y : 1
                        },
						framerate:8,
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT
                    },
					runUp : {
                        frames : {
                            x : "1:4",
                            y : 7
                        },
						framerate:8,
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT
                    },
                    runDown : {
                        frames : {
                            x : "1:4",
                            y : 6
                        },
						framerate:8,
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT
                    },
					work : {
                        frames : {
                            x : "1:4",
                            y : 3
                        },
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT,
						cues:[
							1 => "hit"
						],
						framerate:4
                    },
                    idle : {
                        frames : {
                            x : "1:4",
                            y : 4
                        },
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT,
						cues:[
							1 => "hit"
						],
						framerate:2
                    },
                    shocked : {
                        frames : {
                            x : "1:2",
                            y : 5
                        },
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT,
						framerate:4
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
                    tileWidth : TILE_WIDTH,
                    tileHeight : TILE_HEIGHT,
                    placements : {
                        slabs : {
							x:"1:3",
							y: 4
						},
                        "wall-down" : {
                            x : "1:3",
                            y : 2
                        },
                        "wall-fill" : {
                            x : "1:3",
                            y : 3
                        },
                        "wall-down-over" : {
                            x : "1:3",
                            y : 1
                        },
						"empty":{
							x : 4,
                            y : 2
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

