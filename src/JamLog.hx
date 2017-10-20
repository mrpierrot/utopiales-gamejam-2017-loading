
/**
 * Class for jam_log
 */
@:final class ClassForJamLog
{
    import jammer.utils.ObjectUtils;
    
    @:meta(Inline())

    public function jam_log(pObject : Dynamic) : Void
    {
        trace(ObjectUtils.trace(pObject));
    }

    public function new()
    {
    }
}


