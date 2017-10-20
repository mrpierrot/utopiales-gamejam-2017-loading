package jammer.engines.sounds;

import flash.media.SoundChannel;
import flash.media.SoundTransform;
import jammer.utils.MathUtils;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class JamSound
{
    public var volume(get, set) : Float;

    public var asset : SoundAsset;
    public var channel : SoundChannel;
    public var loop : Bool;
    public var manager : SoundManager;
    @:allow(jammer.engines.sounds)
    private var _volume : Float;
    
    public function new(pAsset : SoundAsset, pManager : SoundManager, pLoop : Bool = false, pVolume : Float = 1)
    {
        asset = pAsset;
        manager = pManager;
        loop = pLoop;
        volume = pVolume;
    }
    
    public function play() : Void
    {
        channel = asset.sound.play(0, (loop) ? MathUtils.INT32_MAX : 0, new SoundTransform(_volume * manager._volume));
    }
    
    public function stop() : Void
    {
        if (channel != null)
        {
            channel.stop();
        }
    }
    
    private function get_volume() : Float
    {
        return _volume;
    }
    
    private function set_volume(value : Float) : Float
    {
        _volume = value;
        if (channel != null)
        {
            channel.soundTransform.volume = _volume * manager._volume;
        }
        return value;
    }
}

