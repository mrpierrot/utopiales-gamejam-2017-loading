package jammer.utils;

import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class StringUtils
{
    
    public function new()
    {
    }
    
    /**
		 * @TODO à refaire
		 */
    public static function trim(str : String) : String
    {
        if (str == null)
        {
            return "";
        }
        
        var startIndex : Int = 0;
        while (isWhitespace(str.charAt(startIndex)))
        {
            ++startIndex;
        }
        
        var endIndex : Int = Std.int(str.length - 1);
        while (isWhitespace(str.charAt(endIndex)))
        {
            --endIndex;
        }
        
        if (endIndex >= startIndex)
        {
            return str.substring(startIndex, endIndex + 1);
        }
        else
        {
            return "";
        }
    }
    
    /**
		 *  @TODO à refaire
		 */
    public static function isWhitespace(character : String) : Bool
    {
        switch (character)
        {
			case " ":
			case "\t":
			case "\r":
			case "\n":
                return true;
        }
		return false;
    }
    
    public static function repeat(pChar : String, pCount : Int) : String
    {
        var ret : String = "";
        for (i in 0...pCount)
        {
            ret += pChar;
        }
        return ret;
    }
    
    public static function complete(pStr : String, pChar : String, pLength : Int) : String
    {
        return repeat(pChar, pLength - pStr.length) + pStr;
    }
}

