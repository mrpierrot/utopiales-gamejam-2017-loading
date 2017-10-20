package jammer.engines.spawn;

import jammer.collections.NodePool;
import jammer.engines.physics.Entity;
import jammer.process.Process;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Spawn extends Process
{
    
    private var _manager : SpawnManager;
    private var _types : Array<Class<Entity>>;
    public var wave : Array<Entity>;
    public var cx : Int;
    public var cy : Int;
    
    
    
    public function new(pSpawnManager : SpawnManager, pTypes : Array<Class<Entity>>)
    {
        super();
        _manager = pSpawnManager;
        _types = pTypes;
        wave = new Array<Entity>();
        cx = cy = 0;
        paused = false;
    }
    
    
    override public function run(pDelta : Float = 1.0) : Void
    {
        wave.splice(0, wave.length);
        update();
    }
    
    private function update(pDelta : Float = 1.0) : Void
    {
    }
    
    
    @:meta(Inline())

    @:final public function dispose(pEntity : Entity) : Void
    {
        _manager.dispose(pEntity);
    }
}

