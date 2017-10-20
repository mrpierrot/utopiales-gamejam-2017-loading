
/**
 * Class for jam_graph_add
 */
@:final class ClassForJamGraphAdd
{
    import jammer.debug.GraphDebug;
    

    public function inline jam_graph_add(pName : String, pValue : Float) : Void
    {
        GraphDebug.addValue(pName, pValue);
    }

    public function new()
    {
    }
}


