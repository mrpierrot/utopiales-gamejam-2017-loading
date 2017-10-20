package jammer.utils;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.filters.BitmapFilter;
import flash.filters.ColorMatrixFilter;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class FilterUtils
{
    
    public function new()
    {
    }
    
    /*
		 * Constantes necessaires à la manipulation des couleurs 
		 */
    private static inline var rs : Float = 0.3086;
    private static inline var gs : Float = 0.6094;
    private static inline var bs : Float = 0.0820;
    
    /**
		 * Cette methode permet de creer un filtre de colorisation
		 * @param	pColor la couleur de coloriage
		 * @param	pRate le degres d'application de la couleur (entre 0 et 1)
		 * @param	pAlpha l'alpha de l'image (entre 0 et 1)
		 */
    public static function color(pColor : Int, pRate : Float = 1, pAlpha : Float = 1) : BitmapFilter
    {
        if (pRate > 1)
        {
            pRate = 1;
        }
        if (pRate < 0)
        {
            pRate = 0;
        }
        if (pAlpha > 1)
        {
            pAlpha = 1;
        }
        if (pAlpha < 0)
        {
            pAlpha = 0;
        }
        var rh : Int = pColor >> 16;
        var gb : Int = Std.int(pColor - (rh << 16));
        var gh : Int = gb >> 8;
        var bh : Int = Std.int(gb - (gh << 8));
        var p : Float = pRate / 1;
        return new ColorMatrixFilter(
        [1 - p + p * rh * rs, p * rh * gs, p * rh * bs, 0, 0, 
        p * gh * rs, 1 - p + p * gh * gs, p * gh * bs, 0, 0, 
        p * bh * rs, p * bh * gs, 1 - p + p * bh * bs, 0, 0, 
        0, 0, 0, pAlpha, 0
    ]);
    }
    
    /**
		 * Cette methode permet de creer un filtre de colorisation
		 * @param	pColor la couleur de coloriage
		 * @param	pRate le degres d'application de la couleur (entre 0 et 1)
		 * @param	pAlpha l'alpha de l'image (entre 0 et 1)
		 */
    public static function alpha(pAlpha : Float = 1) : BitmapFilter
    {
        if (pAlpha > 1)
        {
            pAlpha = 1;
        }
        if (pAlpha < 0)
        {
            pAlpha = 0;
        }
        return new ColorMatrixFilter(
        [1, 0, 0, 0, 0, 
        0, 1, 0, 0, 0, 
        0, 0, 1, 0, 0, 
        0, 0, 0, pAlpha, 0
    ]);
    }
    
    
    /**
		 * Cette methode permet de creer un filtre de desaturation
		 * @param	pDesaturate le degree de desaturation (entre 0 et 1)
		 * @param	pAlpha l'apha de l'image (entre 0 et 1)
		 */
    public static function desaturate(pDesaturate : Float = 1, pAlpha : Float = 1) : BitmapFilter
    {
        if (pDesaturate > 1)
        {
            pDesaturate = 1;
        }
        if (pDesaturate < 0)
        {
            pDesaturate = 0;
        }
        if (pAlpha > 1)
        {
            pAlpha = 1;
        }
        if (pAlpha < 0)
        {
            pAlpha = 0;
        }
        return new ColorMatrixFilter(
        [rs + (1 - pDesaturate) * (1 - rs), gs * pDesaturate, bs * pDesaturate, 0, 0, 
        rs * pDesaturate, gs + (1 - pDesaturate) * (1 - gs), bs * pDesaturate, 0, 0, 
        rs * pDesaturate, gs * pDesaturate, bs + (1 - pDesaturate) * (1 - bs), 0, 0, 
        0, 0, 0, pAlpha, 0
    ]);
    }
    
    /**
		 * 
		 * @param	pObj l'objet dont on veux modifier les filtres
		 * @param	pFilters un tableau contenant des BitmapFilter à ajouter
		 */
    public static function addFilters(pObj : DisplayObject, pFilters : Array<BitmapFilter>, pFirst : Bool = false) : Void
    {
        if (!pFirst)
        {
            pObj.filters = pObj.filters.concat(pFilters);
        }
        else
        {
            pObj.filters = pFilters.concat(pObj.filters);
        }
    }
    
    /**
		 * 
		 * @param	pObj l'objet dont on veux modifier les filtres
		 * @param	pFilters un tableau contenant des BitmapFilter à supprimer
		 */
    public static function removeFilters(pObj : DisplayObject, pFilters : Array<Dynamic>) : Void
    {
        var i : Int;
        var tab : Array<BitmapFilter> = pObj.filters;//.concat();
        for (f in pFilters)
        {
            i = Lambda.indexOf(tab, f);
            if (i != -1)
            {
                tab.splice(i, 1);
            }
        }
        pObj.filters = tab;
    }
}

