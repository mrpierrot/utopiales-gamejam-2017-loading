package jammer.engines.sounds;

import flash.media.Sound;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class SoundManager
{
    public var volume(get, set) : Float;

    private var _sounds : Map<String,JamSound>;
    private var _currentMusic : JamSound;
    @:allow(jammer.engines.sounds)
    private var _volume : Float;
    
    public static var instance : SoundManager = new SoundManager();
    
    public function new()
    {
        _sounds = new Map<String,JamSound>();
        _volume = 1;
    }
    
    public function importFromMap(pList : Map<String,Class<Sound>>) : Void
    {
        for (name in pList.keys())
        {	
            _sounds[name] = new JamSound(new SoundAsset(name, cast((Type.createInstance(pList[name], [])), Sound)), this);
        }
    }
    
    public function playMusic(pName : String, pLoop : Bool = true) : Void
    {
        if (_sounds.exists(pName))
        {
            if (_currentMusic != _sounds[pName])
            {
                if (_currentMusic != null)
                {
                    _currentMusic.stop();
                }
                _currentMusic = _sounds[pName];
                _currentMusic.loop = pLoop;
                _currentMusic.play();
            }
        }
    }
    
    public function stopMusic() : Void
    {
        if (_currentMusic != null)
        {
            _currentMusic.stop();
        }
    }
    
    public function playSFX(pName : String) : Void
    {
        if (_sounds.exists(pName))
        {
            _sounds[pName].play();
        }
    }
    
    public function stopSFX(pName : String) : Void
    {
        if (_sounds.exists(pName))
        {
           _sounds[pName].stop();
        }
    }
    
    private function get_volume() : Float
    {
        return _volume;
    }
    
    private function set_volume(value : Float) : Float
    {
        _volume = value;
        for (sound in _sounds)
        {
            if (sound.channel!=null)
            {
                sound.channel.soundTransform.volume = sound._volume * _volume;
            }
        }
        return value;
    }
}

