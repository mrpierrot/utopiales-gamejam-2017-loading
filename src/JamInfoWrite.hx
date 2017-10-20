
/**
 * Class for jam_info_write
 */
@:final class ClassForJamInfoWrite
{
    import jammer.debug.DebugInfos;
    
    
    public function jam_info_write(pId : String, pValues : Array<Dynamic> = null) : Void
    {
        DebugInfos.updateLine.apply(this, [pId].concat(pValues));
    }

    public function new()
    {
    }
}


