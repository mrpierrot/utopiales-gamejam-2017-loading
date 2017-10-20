
/**
 * Class for jam_info_create
 */
@:final class ClassForJamInfoCreate
{
    import jammer.debug.DebugInfos;
    
    
    public function jam_info_create(pId : String, pLabel : String = null, pValues : Array<Dynamic> = null) : Void
    {
        DebugInfos.createLine.apply(this, [pId, pLabel].concat(pValues));
    }

    public function new()
    {
    }
}


