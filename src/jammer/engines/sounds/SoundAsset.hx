package jammer.engines.sounds;

import flash.media.Sound;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class SoundAsset
{
    
    public var name : String;
    public var sound : Sound;
    
    public function new(pName : String, pSound : Sound)
    {
        name = pName;
        sound = pSound;
    }
}

