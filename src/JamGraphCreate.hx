
/**
 * Class for jam_graph_create
 */
@:final class ClassForJamGraphCreate
{
    import jammer.debug.GraphDebug;
    
    
    
    public function jam_graph_create(pName : String, pColor : Int = 0xFF0000, pScaleX : Float = 10, pScaleY : Float = 10) : Void
    {
        GraphDebug.create(pName, pColor, pScaleX, pScaleY);
    }

    public function new()
    {
    }
}


