package jammer.engines.spawn;

import haxe.ds.ObjectMap;
import jammer.collections.Pool;
import jammer.engines.level.Level;
import jammer.engines.physics.Entity;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class SpawnManager
{
    @:allow(jammer.engines.spawn)
    private var _pools : Map<String,Pool>;
    @:allow(jammer.engines.spawn)
    private var _types : Array<Class<Entity>>;
    @:allow(jammer.engines.spawn)
    private var _level : Level;
    
    public function new(pLevel : Level, pTypes : Array<Class<Entity>>, pInitCount : Int = 100, pGrowCount : Int = 100)
    {
        _level = pLevel;
        _types = pTypes;
        _pools = new Map<String,Pool>();
        var pool : Pool;
        var type : Class<Entity>;
        var i : Int = 0;
        var c : Int = _types.length;
        while (i < c)
        {
            type = _types[i];
            pool = new Pool(type, pInitCount, pGrowCount);
            _pools[Type.getClassName(type)] = pool;
            i++;
        }
    }
    
    public inline function createRandomSpawn(pTypes : Array<Class<Entity>>, pCx : Int, pCy : Int, pLimit : Int = -1, pFrequency : Int = 12) : RandomSpawn
    {
        var spawn : RandomSpawn = new RandomSpawn(this, pTypes);
        spawn.cx = pCx;
        spawn.cy = pCy;
        spawn.limit = pLimit;
        spawn.waveFrequency = pFrequency;
        return spawn;
    }
    


    public inline function create(pType : Class<Entity>) : Entity
    {
		var type:String = Type.getClassName(pType);
        if (_pools.exists(type))
        {
            return cast((cast((_pools[type]), Pool).create()), Entity);
        }
        return null;
    }
    


    public inline function dispose(pEntity : Entity) : Void
    {
        var type : String = Type.getClassName(Type.getClass(pEntity));
        if (_pools.exists(type))
        {
            cast((_pools[type]), Pool).dispose(pEntity);
        }
    }
}

