package jammer.engines.level.gen.dungeon;

import haxe.Constraints.Function;
import jammer.collections.Enumeration;
import jammer.collections.PriorityQueue;
import jammer.engines.level.Cell;
import jammer.engines.level.gen.dungeon.Corridor;
import jammer.engines.level.ILevelStructure;
import jammer.engines.level.Level;
import jammer.engines.pathfinding.AStar;
import jammer.utils.DungeonGeneratorUtils;
import jammer.utils.MathUtils;
import flash.utils.Dictionary;
import haxe.ds.ObjectMap;


@:struct class DungeonGeneratorConf {
	public var roomMin:Int;
	public var roomMax:Int;
	public var roomSizeMin:Int;
	public var roomSizeMax:Int;
	public var thresholdRate:Float;
	public var useExistingCorridors:Bool;
	public var structTypeCreate:Function->String->Dynamic->String;
	public var types:Map<String,Array<String>>;
	public inline function new(
		?roomMin = 10,
		?roomMax = 16,
		?roomSizeMin = 5,
		?roomSizeMax = 9,
		?thresholdRate = 0.6,
		?useExistingCorridors = false,
		?structTypeCreate = null,
		?types = null
	) {
	  this.roomMin = roomMin;
	  this.roomMax = roomMax;
	  this.roomSizeMin = roomSizeMin;
	  this.roomSizeMax = roomSizeMax;
	  this.thresholdRate = thresholdRate;
	  this.useExistingCorridors = useExistingCorridors;
	  this.structTypeCreate = structTypeCreate;
	  this.types = types;
	}
}


/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DungeonGenerator
{
    
    
    
    public function new()
    {
    }
    
    public static var debug : Bool = false;
    
    private static function _log(pParams :String) : Void
    {
        if (!debug)
        {
            return;
        }
        haxe.Log.trace(pParams);
    }
    
    public static function createPseudoLinearLevelBase(pCols : Int, pRows : Int, pTileWidth : Int, pTileHeight : Int, 
		pConf : { 
			roomMin:Int,
			roomMax:Int,
			roomSizeMin:Int,
			roomSizeMax:Int,
			?thresholdRate:Float,
			?useExistingCorridors:Bool,
			?structTypeCreate:Function->String->Dynamic->String,
			?types:Map<String,Array<String>>
		}
	) : DungeonLevel
    {
        if (pConf == null)
        {
            pConf = new DungeonGeneratorConf();
        }
        var roomMin : Int = pConf.roomMin;
        var roomMax : Int = pConf.roomMax;
        var roomSizeMin : Int = pConf.roomSizeMin;
        var roomSizeMax : Int = pConf.roomSizeMax;
        var useExistingCorridors : Bool = pConf.useExistingCorridors || false;
        var structTypeCreate : Function = pConf.structTypeCreate != null?pConf.structTypeCreate:function(pStruct : String, pData : Dynamic = null) : String
        {
			if (pConf.types != null && pConf.types.exists(pStruct)) {
				var arr : Array<String> = pConf.types[pStruct];
                return arr[Std.int(Math.random() * arr.length)];
			}
            return "default";
        };
        var thresholdRate : Float = Reflect.hasField(pConf,"thresholdRate")?pConf.thresholdRate:0.6;
        var level : DungeonLevel;
		var rooms : Array<Room>;
        do
        {
            level = new DungeonLevel(pCols, pRows, pTileWidth, pTileHeight);
            var roomCount : Int = MathUtils.irnd(roomMin, roomMax);
            rooms  = placeRooms(level, roomCount, roomSizeMin, roomSizeMax, structTypeCreate);
            level.rooms.fill(rooms);
        }
        while ((!createPseudoLinearConnections(level, rooms, thresholdRate, structTypeCreate)));
        return level;
    }
    
    public static function placeRooms(pLevel : Level, pRoomCount : Int, pRoomSizeMin : Int, pRoomSizeMax : Int, pStructTypeCreate : Function) : Array<Room>
    {
        var level : Level = pLevel;
        var roomCount : Int = pRoomCount;
        var roomSizeMin : Int = pRoomSizeMin;
        var roomSizeMax : Int = pRoomSizeMax;
        
        var tryingCountInit : Int = 10;
        
        var levelMinSize : Int = MathUtils.min(level.rows, level.cols);
        if (roomSizeMax > levelMinSize)
        {
            roomSizeMax = levelMinSize;
        }
        
        
        var tryingCount : Int = 0;
        
        var rooms : Array<Room> = new Array<Room>();
        
        var room : Room;
        var roomWidth : Int;
        var roomHeight : Int;
        var failedCount : Int = 0;
        var roomId : Int = 1;
        
        //_log("try to create "+roomCount+" rooms");
        while (roomCount > 0)
        {
            room = new Room(roomId, 0, 0, 0, 0, pStructTypeCreate("room"));
            
            roomWidth = MathUtils.irnd(roomSizeMin, roomSizeMax);
            roomHeight = MathUtils.irnd(roomSizeMin, roomSizeMax);
            tryingCount = tryingCountInit;
            //_log("try to create room (w:" + roomWidth + ", h:" + roomHeight);
            while (tryingCount > 0)
            {
                //_log("trying : ",tryingCount);
                room.init(
                        MathUtils.irnd(0, level.cols - roomWidth), 
                        MathUtils.irnd(0, level.rows - roomHeight), 
                        roomWidth, 
                        roomHeight
				);  //_log(room);  ;
                
                if (!room.levelCollide(level))
                {
                    room.updateLevel(level);
                    rooms.push(room);
                    //_log("success")
                    roomId++;
                    roomCount--;
                    break;
                }
                tryingCount--;
            }
            if (tryingCount <= 0)
            {
                failedCount++;
                roomSizeMax = Std.int(MathUtils.max(roomWidth, roomHeight) - failedCount);
                //_log("failed placement");
                //_log("new roomMaxSize : ", roomSizeMax);
                if (roomSizeMax < roomSizeMin)
                {
                    roomSizeMax = roomSizeMin;
                }
                if (roomSizeMax == roomSizeMin)
                {
                    //_log("cannot place min sized room : skip a room and retry")
                    roomCount--;
                }
            }
        }
        
        return rooms;
    }
    
    public static function createPseudoLinearConnections(pLevel : DungeonLevel, pRooms : Array<Room>, pThresholdRate : Float, pStructTypeCreate : Function) : Bool
    {
		var connectionsCount : Map<ILevelStructure,Int> = new Map<ILevelStructure,Int>();
        var links : Enumeration<String> = new Enumeration<String>();
        var roomsCount : Int = pRooms.length;
        if (pThresholdRate < 0)
        {
            pThresholdRate = 0;
        }
        if (pThresholdRate > 1)
        {
            pThresholdRate = 1;
        }
        var threshold : Int = Std.int(roomsCount * (1 - pThresholdRate));
        var corridors : Enumeration<Corridor> = pLevel.corridors;
        var rooms : Enumeration<Room> = new Enumeration<Room>();
        rooms.fill(pRooms);
		
		function sortRooms(pRoom : Room, pLimit : Int, pMainPath : Bool) : PriorityQueue
        {
            var pq : PriorityQueue = new PriorityQueue();
            
            var dist : Float;
            var aRoom : Room;
            var i : Int = 0;
            var c : Int = pRooms.length;
            for (aRoom in pRooms)
            {
               // aRoom = pRooms[i];
                if (pRoom != aRoom)
                {
                    
					dist = DungeonGeneratorUtils.getCellsHeuristic(pRoom.center, aRoom.center)  ;
					var count : Int = connectionsCount[aRoom];
					count++;
					if (count <= pLimit)
					{
						if (count > 1)
						{
							count *= 100;
						}
						if (!pMainPath)
						{
							if (!(aRoom.markers.haveItem("start") || aRoom.markers.haveItem("end"))){
								_log("room : "+ pRoom.id+ ", a room :"+ aRoom.id+ ", count : "+ count+ ", dist : "+ dist);
								if (!isMainPathConnected(aRoom))
								{
									count *= 1000;
									_log("not main : "+ count);
								}
								_log("weight : " + ( dist * count));
							}
							
						}
						pq.insert(aRoom, Std.int(( dist * count)));
					}
				}
               // i++;
            }
            return pq;
        }
		
		function createCorridor(pRoom : Room, pLimit : Int, pMainPath : Bool, pUseExistingCorridors : Bool, pStructTypeCreate : Function) : Room
        {
            var pq : PriorityQueue = sortRooms(pRoom, pLimit, pMainPath);
            _log("--------------------");
			
			var sort:Int->Int->Int = function(pA:Int,pB:Int):Int{
				if (pA > pB) return 1;
				if (pA < pB) return -1;
				return 0;
			};
            while (!pq.empty())
            {
                var room : Room = pq.removeFirst();
				var structsIds:Array<Int> = [pRoom.id, room.id];
                structsIds.sort(sort);
				var linkId : String = structsIds.join(":");
                _log("linkId : " + linkId);
                if (!links.haveItem(linkId))
                {
                    _log("try to connect "+ pRoom.id+ "and"+ room.id);
                    var corridor : Corridor = getCorridor(pLevel, pRoom, room, pStructTypeCreate, pUseExistingCorridors);
                    if (corridor.cells.length > 0)
                    {
                        corridor.updateLevel(pLevel);
                        corridors.putItem(corridor);
						connectionsCount[pRoom] = connectionsCount[pRoom] + 1;
						connectionsCount[room] = connectionsCount[room] + 1;
                        rooms.removeItem(pRoom);
                        links.putItem(linkId);
                        room.links.putItem(corridor);
                        pRoom.links.putItem(corridor);
                        corridor.links.putItem(pRoom);
                        corridor.links.putItem(room);
                        if (pMainPath)
                        {
                            corridor.markers.putItem("mainpath");
                            room.markers.putItem("mainpath");
                        }
                        _log(pRoom.id+ " connect to "+ room.id);
                        _log(pRoom.id + " connections :  " + Reflect.field(connectionsCount, Std.string(pRoom)));
                        _log(room.id + " connections :  " + Reflect.field(connectionsCount, Std.string(room)));
                        _log("rooms not used :"+ rooms.length+ "/"+ roomsCount);
                        
                        return room;
                    }
                    else
                    {
                        _log("connection failed");
                    }
                }
                else
                {
                    _log("linkId : "+ linkId+ " : corridor allready define");
                }
            }
            return null;
        }
		
       
        
        if (roomsCount > 0)
        {
            var currentRoom : Room = pRooms[0];
            var firstRoom : Room = currentRoom;
            var lastRoom : Room;
            //Reflect.setField(connectionsCount, Std.string(currentRoom), 1);
            connectionsCount[firstRoom] = 1;
            
            firstRoom.markers.putItem("mainpath");
            
            // creation du chemin principal
            _log("===================================");
            _log("main path");
            
            do
            {
                lastRoom = currentRoom;
                //currentRoom = createCorridor(lastRoom, 1).room;
                currentRoom = createCorridor(lastRoom, 1, true, false, pStructTypeCreate);
                if (currentRoom != null) {
					_log(currentRoom.toString()+ rooms.length);
				}
            }
            while ((currentRoom != null && rooms.length > 0));
            _log("lastRoom "+ lastRoom);
            rooms.removeItem(lastRoom);
            _log("rooms not used : "+ rooms.length);
            
            // si le chemin principal comporte moins que "threshold" pieces alors on abandonne
            // cette génération de niveau pour en recommencer une autre
            // Avec "threshold" calculé en fonction du nombre de pieces générées
            if (rooms.length > threshold)
            {
                _log("no enought rooms in the main way. asked : "+( roomsCount - threshold)+ " and "+( roomsCount - rooms.length)+ " given");
                return false;
            }
            
            _log("===================================");
            _log("others paths");
            // On connectes les pieces non connectés
            while (rooms.length > 0)
            {
                _log("#######################");
                currentRoom = rooms.pick();
                _log("start by room " + currentRoom.id);
                do
                {
                    currentRoom = createCorridor(currentRoom, 10, false, true, pStructTypeCreate);
                    if (currentRoom != null)
                    {
                        _log("room :"+ currentRoom.id+ ", mainpath : "+ currentRoom.markers.haveItem("mainpath"));
                    }
                }
                while ((currentRoom != null && !isMainPathConnected(currentRoom) && rooms.length > 0));
            }
            _log(" rest : "+ rooms.length);
            
            firstRoom.markers.putItem("start");
            lastRoom.markers.putItem("end");
            pLevel.startRoom = firstRoom;
            pLevel.endRoom = lastRoom;
            return true;
        }
        
        return false;
        

        
        
    }
    
    public static function isMainPathConnected(pStruct : ILevelStructure) : Bool
    {
        //if (pStruct.markers.haveItem("mainpath")) return true;
        var structs : Enumeration<ILevelStructure> = new Enumeration<ILevelStructure>();
        function selectNextStruct (pStruct : ILevelStructure) : Bool
        {
            //_log(pStruct.links);
            if (pStruct.markers.haveItem("mainpath"))
            {
                return true;
            }
            structs.putItem(pStruct);
            for (struct in pStruct.links.iterator)
            {
                //_log("struct", struct);
                if (!structs.haveItem(struct))
                {
                    if (selectNextStruct(cast(struct,ILevelStructure)))
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        
        return selectNextStruct(pStruct);
    }
    
    public static function getCorridor(pLevel : Level, pRoomA : Room, pRoomB : Room, pStructTypeCreate : Function, pUseExistingCorridors : Bool = true) : Corridor
    {
        var level : Level = pLevel;
        var neightbors : Array<Cell> = new Array<Cell>();
        var start : Cell = pRoomA.center;
        var goal : Cell = pRoomB.center;
        var result : ObjectMap<Dynamic,Dynamic> = AStar.search(
                start, 
                goal, 
                DungeonGeneratorUtils.createCorridorNeighborsCellsFunction(level, start, goal, pUseExistingCorridors), 
                DungeonGeneratorUtils.getCellsHeuristic, 
                DungeonGeneratorUtils.getCellsHeuristic
        );
        
        var corridor : Corridor = new Corridor(pStructTypeCreate("corridor"));
        var current : Cell = start;
        var next : Cell;
        do
        {
            //_log("result : ",current);
            next = result.get(current);
            if (next != null)
            {
                if (Std.is(next.structure, Corridor) && next.structure != corridor)
                {
                    cast((next.structure), Corridor).merge(corridor);
                    corridor = cast((next.structure), Corridor);
                }
                else
                {
                    if (!(Std.is(next.structure, Room)))
                    {
                        corridor.addCell(next);
                    }
                }
            }
            current = next;
        }
        while (current!=null);
        return corridor;
    }
}

