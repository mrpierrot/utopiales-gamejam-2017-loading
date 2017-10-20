package jammer.utils;

import flash.display.DisplayObject;
import flash.utils.ByteArray;

/**
	* ...
	* @author Default
	*/
class ObjectUtils
{
    
    public static function clone(pObject : Dynamic) : Dynamic
    {
        var ret : Dynamic = { };
        for (name in Reflect.fields(pObject))
        {
            Reflect.setField(ret, name, Reflect.field(pObject, name));
        }
        return ret;
    }
    
    
    public static function trace(pObj : Dynamic, pInline : Bool = false) : String
    {
        if (Std.is(pObj, Float) || Std.is(pObj, Bool) || Std.is(pObj, Int) || Std.is(pObj, String) || Std.is(pObj, Int))
        {
            return Std.string(pObj);
        }
        return _traceR(pObj, 0, pInline);
    }
    
    
    private static function _traceR(pLog : Dynamic, pNv : Int = 0, pInline : Bool = false) : String
    {
        if (Std.is(pLog, Float) || Std.is(pLog, Bool) || Std.is(pLog, Int) || Std.is(pLog, String) || Std.is(pLog, Int))
        {
            return Std.string(pLog);
        }
        
        var str : String = Type.getClassName(pLog);
        var strAttr : String = "";
        var espace : String = " ";
        var espaceFermeture : String = "";
        var endline : String = (pInline) ? " " : "\n";
        for (i in 0...pNv)
        {
            espace += " ";
            espaceFermeture += " ";
        }
        var nv : Int = Std.int(pNv + 1);
        if (Std.is(pLog, Array))
        {
            var struct : Dynamic = pLog;
            str += "::[" + endline;
            var j : Int = 0;
            var c : Int = struct.length;
            while (j < c)
            {
                str += espace + _traceR(Reflect.field(struct, Std.string(j)), nv) + endline;
                j++;
            }
            str += "]" + endline;
        }
        else
        {
            for (attr in Reflect.fields(pLog))
            {
                if (Reflect.field(pLog, attr) != null && (Type.typeof(Reflect.field(pLog, attr)) == TObject))
                {
                    strAttr += espace + attr + " => " + _traceR(Reflect.field(pLog, attr), nv) + endline;
                }
                else
                {
                    strAttr += espace + attr + " => " + Reflect.field(pLog, attr) + endline;
                }
            }
            if (strAttr.length > 0)
            {
                str += "(" + endline + strAttr + espaceFermeture + ")";
            }
            else
            {
                str += "";
            }
        }
        
        return (str);
    }

    public function new()
    {
    }
}

