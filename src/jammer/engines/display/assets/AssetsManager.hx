package jammer.engines.display.assets;

import flash.errors.Error;
import jammer.engines.display.assets.parsers.DumbParser;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.display.text.JamFlashText;
import jammer.engines.display.types.JamSprite;
import jammer.engines.display.types.JamTiles;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Dictionary;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class AssetsManager
{
    public static var instance(get, never) : AssetsManager;

    
    public var defaultFont : String;
    
    private var _assets : Map<String,Asset>;
    
    public function new()
    {
        _assets = new Map<String,Asset>();
    }
    
    public function register(pAsset : Asset) : Void
    {
        if (pAsset == null)
        {
            throw new Error("Asset cannot be null !");
        }
        
        _assets[pAsset.name] = pAsset;
    }
    
    public function getAsset(pName : String) : Asset
    {
        return _assets[pName];
    }
    
    public function getBitmap(pName : String) : BitmapData
    {
        return cast((_assets[pName]), Asset).data;
    }
    
    public function getTileSetAsset(pName : String) : TileSetAsset
    {
        return cast(_assets[pName],TileSetAsset);
    }
    
    public function importClip(pName : String, pData : BitmapData, pStates : Map<String,AnimationState>, pInitStateName : String) : AnimationAsset
    {
		_assets[pName] = new AnimationAsset(pName, pData, pStates, pInitStateName);
        return cast(_assets[pName],AnimationAsset);
    }
    
    public function importTileSet(pName : String, pData : BitmapData, pPlacements : Map<String,Array<Rectangle>>) : TileSetAsset
    {
		_assets[pName] = new TileSetAsset(pName, pData, pPlacements);
        return cast(_assets[pName],TileSetAsset);
    }
    
    public function importSprite(pName : String, pData : BitmapData) : Asset
    {
		_assets[pName] = new Asset(pName, pData);
        return cast(_assets[pName],Asset);
    }
    
    public function importFromClassMap(pClassMap : Class<Dynamic>) : Void
    {
        var clazz : Class<Dynamic>;
        var name : String;
        var instance : Dynamic;
		trace(Reflect.fields(pClassMap));
       	for (name in Reflect.fields(pClassMap))
		{
			clazz = Reflect.field(pClassMap, name);
			trace("pouet : "+clazz);
            if (name != null && Std.is(clazz, Class))
            {
                instance = Type.createInstance(clazz, []);
                if (Std.is(instance, Bitmap))
                {
                    _assets[name] = new Asset(name, cast((instance), Bitmap).bitmapData);
                }
            }
        }
        var classMapInstance : Dynamic = Type.createInstance(pClassMap, []);
        if (Std.is(classMapInstance, IAssets))
        {
            var assets : IAssets = cast((classMapInstance), IAssets);
			
			var sprites:Map <String, Class<BitmapData>> = assets.getSprites();
			if(sprites!=null){
				for (name in sprites.keys()) {
					_assets[name] = new Asset(name,Type.createInstance(sprites[name], [0,0 ]));
				}
			}
			
			
            var animations : Dynamic = assets.getAnimations();
            var anim : Dynamic;
            var bmp : BitmapData;
            var states : Map<String,AnimationState>;
            var assetData : Class<Dynamic>;
            
            for (name in Reflect.fields(animations))
            {
                anim = Reflect.field(animations, name);
                bmp = null;
                states = null;
                assetData = anim.asset;
                if (Std.is(assetData, Class))
                {
                    bmp = Type.createInstance(assetData, [0,0 ]);
                }
                if (Std.is(assetData, Bitmap))
                {
                    bmp = cast((assetData), Bitmap).bitmapData;
                }
                else
                {
                    if (Std.is(assetData, BitmapData))
                    {
                        bmp = cast(assetData,BitmapData);
                    }
                }
                if (bmp != null)
                {
                    states = DumbParser.parseAnimations(anim.states, bmp.width, bmp.height, anim.framerate);
                    if (states != null)
                    {
                        this.importClip(name, bmp, states, anim.initState);
                    }
                }
            }
            
            var tilesSets : Dynamic = assets.getTileSets();
            var tileSet : Dynamic;
            var placements : Map<String,Array<Rectangle>>;
            for (name in Reflect.fields(tilesSets))
            {
                tileSet = Reflect.field(tilesSets, name);
                bmp = null;
                placements = null;
                assetData = tileSet.asset;
                if (Std.is(assetData, Class))
                {
                    bmp = Type.createInstance(assetData,[0,0]);
                }
                if (Std.is(assetData, Bitmap))
                {
                    bmp = cast((assetData), Bitmap).bitmapData;
                }
                else
                {
                    if (Std.is(assetData, BitmapData))
                    {
                        bmp = cast(assetData,BitmapData);
                    }
                }
                if (bmp != null)
                {
                    placements = new Map<String,Array<Rectangle>>();
                    for (format in cast(tileSet.formats,Array<Dynamic>))
                    {
                        DumbParser.parseTileSet(placements, format.placements, format.tileWidth, format.tileHeight, format.startY, bmp.width, bmp.height);
                    }
                    this.importTileSet(name, bmp, placements);
                }
            }
        }
    }
    
    /**
		 * @todo
		 * @param	pName
		 * @param	pData
		 * @param	pConf
		 * @return
		 */
    public function importSpritesheet(pName : String, pData : BitmapData, pConf : Dynamic) : Asset
    {
        return null;
    }
    
    /**
		 * @todo
		 * @param	pName
		 * @param	pData
		 * @param	pJSON
		 * @return
		 */
    public function importClipFromJSON(pName : String, pData : BitmapData, pJSON : String) : AnimationAsset
    {
        return null;
    }
    
    public function importFontsLib(pFonts : Array<Class<Font>>) : Void
    {
        for (font in pFonts)
        {
            Font.registerFont(font);
			
			var f:Font = cast(Type.createInstance(font,[]),Font);
			trace(f.fontName);
			
        }
    }
    
    public function createAnimation(pName : String, pDefaultState : String = null, pLoop : Bool = true, pEventsEnabled : Bool = false) : JamAnimation
    {
        var asset : AnimationAsset = cast(_assets[pName],AnimationAsset);
        return new JamAnimation(asset, pDefaultState, pLoop, pEventsEnabled);
    }
    
    public function createSprite(pName : String) : JamSprite
    {
        var asset : Asset = _assets[pName];
        return new JamSprite(asset);
    }
    
    public function createText(pText : String, pSize : Int = 8, pColor : Int = 0xFFFFFF, pFont : String = null) : JamFlashText
    {
        var format : TextFormat = new TextFormat((pFont != null) ? pFont : defaultFont, pSize, pColor);
        var tf : JamFlashText = new JamFlashText();
        tf.text.defaultTextFormat = format;
        tf.text.setTextFormat(format);
        tf.text.htmlText = pText;
        tf.text.embedFonts = true;
        tf.text.multiline = true;
        tf.text.autoSize = TextFieldAutoSize.LEFT;
        tf.text.selectable = tf.text.mouseEnabled = tf.text.mouseWheelEnabled = false;
        return tf;
    }
    
    public function createFlashText(pText : String, pSize : Int = 8, pColor : Int = 0xFFFFFF, pFont : String = null, ?pAlign : TextFieldAutoSize) : TextField
    {
        var format : TextFormat = new TextFormat((pFont != null) ? pFont : defaultFont, pSize, pColor);
        var tf : TextField = new TextField();
        tf.defaultTextFormat = format;
        tf.setTextFormat(format);
        tf.htmlText = pText;
        tf.embedFonts = true;
        tf.multiline = true;
        tf.autoSize = pAlign;
        tf.selectable = tf.mouseEnabled = tf.mouseWheelEnabled = false;
        return tf;
    }
    
    private static var _instance : AssetsManager;
    
    private static function get_instance() : AssetsManager
    {
        if (_instance == null)
        {
            _instance = new AssetsManager();
        }
        return _instance;
    }
}

