
/**
 * Class for jam_sec2fps
 */
@:final class ClassForJamSec2fps
{
    import jammer.Context;
    
    @:meta(Inline())

    public function jam_sec2fps(pTime : Float) : Int
    {
        return Std.int(pTime * Context.fps + 0.5);
    }

    public function new()
    {
    }
}


