package jammer.assets;
import flash.text.Font;

@:font("jammer/assets/fonts/Fiery_Turk.ttf") class Font_Fiery_Turk extends Font { }
@:font("jammer/assets/fonts/04B_03__.ttf") class Font_04B03 extends Font { }

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class DefaultFontsLib
{
    
    
    public static var DEFAULT : String = "Fiery Turk";

    public static var FONTS:Array<Class<Font>> = [Font_04B03,Font_Fiery_Turk];
	
	
    
    public function new()
    {
		
    }
}

