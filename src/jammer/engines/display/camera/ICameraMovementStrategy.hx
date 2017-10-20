package jammer.engines.display.camera;


/**
	 * ...
	 * @author Pierre Chabiland
	 */
interface ICameraMovementStrategy
{

    function update(pCamera : Camera, pDestX : Int, pDestY : Int) : Void
    ;
}

