package loading;

import jammer.engines.display.assets.IAssets;
import flash.display.BitmapData;

@:bitmap("src/assets/workbench.png") class WorkbenchSprite extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheet.png") class HamsterSprite extends BitmapData { }
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
			"workbench" => WorkbenchSprite
		];
	}
    
    
    public function getAnimations() : Dynamic
    {
		
        return {
            hamster : {
                asset : HamsterSprite,
                framerate : 8,
                initState : "staticRight",
                states : {
               
                    runRight : {
                        frames : {
                            x : "1:4",
                            y : 2
                        },
						framerate:4,
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT
                    },
                    runLeft : {
                        frames : {
                            x : "1:4",
                            y : 1
                        },
						framerate:4,
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
                            x : 1,
                            y : 3
                        },
                        width : TILE_WIDTH,
                        height : TILE_HEIGHT,
						framerate:8
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
							y:2
						},
						slabs2 : {
							x:"1:3",
							y:3
						},
                        "wall-down" : {
                            x : "1:3",
                            y : 1
                        },
                        "wall-fill" : {
                            x : 4,
                            y : 1
                        },
                        "wall-down-over" : {
                            x : "1:3",
                            y : 1
                        },
						"empty":{
							x : 4,
                            y : 1
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

