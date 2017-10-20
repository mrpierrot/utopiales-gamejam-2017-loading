package jammer.engines.level;

import jammer.collections.Enumeration;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
interface ILevelStructure
{
    
    var links(get, never) : Enumeration<ILevelStructure>;    
    var markers(get, never) : Enumeration<String>;

    function updateLevel(pLevel : Level) : Void
    ;
}

