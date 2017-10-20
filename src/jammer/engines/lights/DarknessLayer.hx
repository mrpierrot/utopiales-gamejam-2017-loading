package jammer.engines.lights;

import jammer.engines.display.types.JamBitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.BlendMode;
import flash.geom.ColorTransform;

/**
	 * ...
	 * @author ...
	 */
class DarknessLayer extends JamBitmap
{
    private var alphaMap : Array<Int>;
    private var otherMap : Array<Int>;
    
    public function new(pWidth : Int, pHeight : Int, pMinAlpha : Int = 40, pMaxAlpha : Int = 255, pThreshold : Int = 40, ?pBlendMode : BlendMode)
    {
		if (pBlendMode == null) pBlendMode = BlendMode.DARKEN;
		
        // on monte une layer qui ne gere que l'obscurité.
        // ce qui permet d'appliquer un blend mode different de la lumiere.
        // Un OVERLAY c'est moche, on va lui preferer un MULTIPLY.
        // Pour ça, on va exploiter BitmapData.paletteMap qui va permetre d'inverser
        // les alpha de la couche de lumiere, pour avoir un calque "obscurite"
        // avec des trous aux emplacement de la lumiere
        // au passage, on va mettre un seuil aux alpha pour un meilleur rendu visuel
        alphaMap = [];
        otherMap = [];
        var minAlpha : Int = pMinAlpha;
        var maxAlpha : Int = pMaxAlpha;
        var treshold : Int = pThreshold;
        for (a in 0...256)
        {
            otherMap[a] = 0xFF000000;
            var val : Int = Std.int(255 - a - treshold);
            if (val < minAlpha)
            {
                val = minAlpha;
            }
            if (val > maxAlpha)
            {
                val = maxAlpha;
            }
            alphaMap[a] = val << 24;
        }
        super(new BitmapData(pWidth, pHeight, true, 0xFF000000));
        this.transformEnabled = true;
        this.blendMode = pBlendMode;
        //darknessLayer.color = new ColorTransform();
        //darknessLayer.blendMode = BlendMode.MULTIPLY;
        this.color = new ColorTransform(1, 1, 1, 1);
    }
    
    
    public function update(pLightsContainer : LightsContainer) : Void
    {
        this.bitmapData.fillRect(pLightsContainer.postRenderingSource, 0x00000000);
        //trace(this.x, this.y);
        this.bitmapData.paletteMap(pLightsContainer.bitmapData, pLightsContainer.postRenderingSource, pLightsContainer.postRenderingDestPoint, otherMap, otherMap, otherMap, alphaMap);
    }
}

