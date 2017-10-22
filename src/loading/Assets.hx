package loading;

import flash.media.Sound;
import jammer.engines.display.assets.IAssets;
import flash.display.BitmapData;

@:bitmap("src/assets/workbench1.png") class WorkbenchSprite1 extends BitmapData { }
@:bitmap("src/assets/workbench2.png") class WorkbenchSprite2 extends BitmapData { }
@:bitmap("src/assets/workbench3.png") class WorkbenchSprite3 extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheet.png") class HamsterSprite extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheetContour.png") class HaloSprite extends BitmapData { }
@:bitmap("src/assets/HamSpriteSheetShock.png") class ShockSprite extends BitmapData { }
@:bitmap("src/assets/wallGround1.png") class Tiles extends BitmapData { }
@:bitmap("src/assets/level-all.png") class DemoLevel extends BitmapData { }
@:bitmap("src/assets/Cursor-Sheet.png") class CursorSheet extends BitmapData { }

@:sound('src/assets/sfx/Loading - BGM2 v1.mp3') class Sfx_Music extends Sound { }
@:sound('src/assets/sfx/electrocute2.mp3') class Sfx_Shock extends Sound { }
@:sound('src/assets/sfx/lemming1.mp3') class Sfx_HamsterShock extends Sound { }

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
	
	public static var sounds:Map<String,Class<Sound>> = [ 
		"music" => Sfx_Music,
		"shock" => Sfx_Shock,
		"hamster-shock" => Sfx_HamsterShock
	];
	
	public function getSprites():Map<String, Class<BitmapData>> 
	{
		return [
			"level" => DemoLevel,
			"workbench1" => WorkbenchSprite1,
			"workbench2" => WorkbenchSprite2,
			"workbench3" => WorkbenchSprite3,
			"halo" => HaloSprite,
			"shocked" => ShockSprite
		];
	}
    
    
    public function getAnimations() : Dynamic
    {
		
        return {
			cursor : {
                asset : CursorSheet,
                framerate : 1,
                initState : "pointer",
                states : {
					pointer : {
						frames: "0",
						width : 20,
                        height : 20
					},
					shock1 : {
						frames: "1",
						width : 20,
                        height : 20
					},
					shock2 : {
						frames: "2",
						width : 20,
                        height : 20
					}
					
				}
			},
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

