package jammer.engines.spawn;

import jammer.engines.physics.Entity;
import jammer.utils.MathUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class RandomSpawn extends Spawn
{
    public var limit : Int;
    public var waveFrequency : Int;
    public var waveMinSize : Int;
    public var waveMaxSize : Int;
    public var _loop : Int;
    public var _count : Int;
    public function new(pManager : SpawnManager, pTypes : Array<Class<Entity>>)
    {
        super(pManager, pTypes);
        limit = -1;
        _count = 0;
        waveFrequency = 6;
        waveMinSize = waveMaxSize = 1;
        _loop = 0;
    }
    
    private var _i : Int;
    private var _waveSize : Int;
    private var _type : Class<Entity>;
    private var _item : Entity;
    override private function update(pDelta : Float = 1.0) : Void
    {
		_loop++;
        if (_loop % waveFrequency != 0)
        {
            return;
        }
        _waveSize = MathUtils.irnd(waveMinSize, waveMaxSize);
        if (limit <= 0 || _count < limit)
        {
            if (limit > 0 && _waveSize + _count >= limit)
            {
                _waveSize = Std.int(limit - _count);
            }
            for (_i in 0..._waveSize)
            {
                _type = _types[Std.int(_types.length * Math.random())];
                _item = _manager.create(_type);
                _item.reset();
                _item.level = _manager._level;
                _item.setCellPosition(cx, cy);
                _count++;
                wave.push(_item);
            }
        }
    }
}

