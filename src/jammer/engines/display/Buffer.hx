package jammer.engines.display;

import jammer.engines.display.camera.Camera;
import jammer.engines.display.types.JamAnimation;
import jammer.engines.display.types.JamDisplayObject;
import jammer.utils.MathUtils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.filters.BitmapFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Pierre Chabiland
	 */
class Buffer extends Sprite
{
    public var scale(get, set) : Float;
    public var renderingWidth(get, never) : Int;
    public var renderingHeight(get, never) : Int;

    public var camera : Camera;
    private var _dm : DepthManager;
    private var _displayObjectList : Array<JamDisplayObject>;
    private var _rendering : BitmapData;
    private var _transformBuffer : BitmapData;
    private var _buffer : BitmapData;
    private var _height : Int;
    private var _width : Int;
    private var _originalWidth : Int;
    private var _originalHeight : Int;
    private var _backgroundColor : Int;
    private var _centerX : Int;
    private var _centerY : Int;
    private var _frameId : Int;
    private var _backgrounColor : Int;
    private var _destPoint : Point;
    private var _destMatrix : Matrix;
    private var _bufferRect : Rectangle;
    private var _sourceRect : Rectangle;
    private var _texture : Bitmap;
    private var _scale : Float;
    private var _container : Bitmap;
    public var postFilters : Array<BitmapFilter>;
    public var localMouseX : Int;
    public var localMouseY : Int;
    
    public function new(pWidth : Int, pHeight : Int, pDM : DepthManager, pScale : Float = 1, pColor : Int = 0xFF000000)
    {
        super();
        _originalWidth = pWidth;
        _originalHeight = pHeight;
        _backgroundColor = pColor;
        _dm = pDM;
        camera = new Camera(_width, _height);
        _backgrounColor = pColor;
        _displayObjectList = _dm.children;
        _frameId = 0;
        _destPoint = new Point();
        _destMatrix = new Matrix();
        _sourceRect = new Rectangle();
        _container = new Bitmap(_rendering,PixelSnapping.AUTO,false);
        scale = pScale;
        
        this.addChild(_container);
        this.mouseChildren = this.mouseEnabled = false;
        postFilters = new Array<BitmapFilter>();
    }
    
    
    public function setTexture(pMozaic : BitmapData, pAlpha : Float = 0.3, pBlendMode : BlendMode = null) : Void
    {
		if (pBlendMode == null) pBlendMode = BlendMode.OVERLAY;
        if (_texture == null)
        {
            _texture = new Bitmap(new BitmapData(Std.int(_width * _scale), Std.int(_height * _scale), true, 0xFF000000));
            this.addChild(_texture);
        }
        var spr : Sprite = new Sprite();
        var g : Graphics = spr.graphics;
        g.beginBitmapFill(pMozaic, null, true, false);
        g.drawRect(0, 0, _width * _scale, _height * _scale);
        g.endFill();
        _texture.bitmapData.draw(spr);
        _texture.alpha = pAlpha;
        _texture.blendMode = pBlendMode;
    }
    
    private var _i : Int;
    private var _c : Int;
    private var _item : JamDisplayObject;
    private var _frameData : FrameData;
    private var _repeatSourceX : Float;
    private var _repeatSourceY : Float;
    private var _repeatSourceW : Float;
    private var _repeatSourceH : Float;
    private var _repeatXCount : Int;
    private var _repeatAnteCount : Int;
    private var _repeatYCount : Int;
    private var _repeatStartX : Int;
    private var _repeatStartY : Int;
    private var _repeatDir : Int;
    private var _cameraX : Int;
    private var _cameraY : Int;
    private var _j : Int;private var _k : Int;
    public function update() : Void
    {
        _frameId = Std.int((_frameId + 1) % 147483647);
        _c = _displayObjectList.length;
        _buffer.fillRect(_bufferRect, _backgrounColor);
        camera.update();
        //for (_i in 0..._c)
		_i = 0;
		while(_i < _c)
        {
            _item = _displayObjectList[_i];
            if (_item.visible)
            {

				if (_item.askRemove)
				{
					_dm.remove(_item);
					_i--;
					_c--;
					_item.destruct();
				}
				else
				{
					_frameData = _item.getFrameData(_frameId);
					if (_frameData != null)
					{
						_cameraX = ((_item.noCamera) ? 0 : Std.int(camera.x * _item.cameraSpeedXRate));
						_cameraY = ((_item.noCamera) ? 0 : Std.int(camera.y * _item.cameraSpeedYRate));
						
						// si gestion de la repetition de motifs
						if (_item.repeatX || _item.repeatY)
						{
							_repeatSourceX = _item.x + _cameraX;
							_repeatSourceY = _item.y + _cameraY;
							_repeatXCount = _repeatYCount = 0;
							
							if (_frameData.asset != null)
							{
								_repeatSourceW = _frameData.source.width;
								_repeatSourceH = _frameData.source.height;
							}
							else
							{
								_repeatSourceW = _frameData.drawable.width;
								_repeatSourceH = _frameData.drawable.height;
							}
							if (_item.repeatX)
							{
								if (_repeatSourceX == 0)
								{
									_repeatStartX = 0;
									_repeatXCount = MathUtils.ceil(_width / _repeatSourceW);
								}
								else
								{
									if (_repeatSourceX > 0)
									{
										_repeatAnteCount = MathUtils.ceil(_repeatSourceX / _repeatSourceW);
										_repeatStartX = Std.int(_repeatSourceX - _repeatAnteCount * _repeatSourceW);
										_repeatXCount = MathUtils.ceil((_width - _repeatStartX) / _repeatSourceW);
									}
									else
									{
										_repeatAnteCount = MathUtils.floor((-_repeatSourceX) / _repeatSourceW);
										_repeatStartX = Std.int(_repeatSourceX + _repeatAnteCount * _repeatSourceW);
										_repeatXCount = MathUtils.ceil((_width - _repeatStartX) / _repeatSourceW);
									}
								}
								if (!_item.repeatY)
								{
									for (_j in 0..._repeatXCount)
									{
										_drawInBuffer(_item, _frameData, _repeatStartX + _j * Std.int(_repeatSourceW), Std.int(_repeatSourceY));
									}
								}
							}
							
							if (_item.repeatY)
							{
								if (_repeatSourceY == 0)
								{
									_repeatStartY = 0;
									_repeatYCount = MathUtils.ceil(_height / _repeatSourceH);
								}
								else
								{
									if (_repeatSourceY > 0)
									{
										_repeatAnteCount = MathUtils.ceil(_repeatSourceY / _repeatSourceH);
										_repeatStartY = Std.int(_repeatSourceY - _repeatAnteCount * _repeatSourceH);
										_repeatYCount = MathUtils.ceil((_height - _repeatStartY) / _repeatSourceH);
									}
									else
									{
										_repeatAnteCount = MathUtils.floor((-_repeatSourceY) / _repeatSourceH);
										_repeatStartY = Std.int(_repeatSourceY + _repeatAnteCount * _repeatSourceH);
										_repeatYCount = MathUtils.ceil((_height - _repeatSourceY) / _repeatSourceH);
									}
								}
								if (!_item.repeatX)
								{
									for (_j in 0..._repeatYCount)
									{
										_drawInBuffer(_item, _frameData, Std.int(_repeatSourceX), _repeatStartY + _j * Std.int(_repeatSourceH));
									}
								}
							}
							if (_item.repeatX && _item.repeatY)
							{
								for (_j in 0..._repeatYCount)
								{
									for (_k in 0..._repeatXCount)
									{
										_drawInBuffer(_item, _frameData, _repeatStartX + _k * Std.int(_repeatSourceW), _repeatStartY + _j * Std.int(_repeatSourceH));
									}
								}
							}
						}
						else
						{
							_drawInBuffer(_item, _frameData, Std.int(_frameData.destination.x + _cameraX), Std.int(_frameData.destination.y + _cameraY));
						}
					}
				}
			}
			_i++;
        }
        
        _destPoint.x = 0;
        _destPoint.y = 0;
		_c = postFilters.length;
        for (_i in 0..._c)
        {
            _buffer.applyFilter(_buffer, _bufferRect, _destPoint, postFilters[_i]);
        }
        _rendering.copyPixels(_buffer, _bufferRect, _destPoint);
        localMouseX = Std.int(0.5 + (this.mouseX / _scale) - camera.x);
        localMouseY = Std.int(0.5 + (this.mouseY / _scale) - camera.y);
    }
    


    private inline function _drawInBuffer(pItem : JamDisplayObject, pFrameData : FrameData, pX : Int, pY : Int) : Void
    {
        if (pFrameData.asset != null)
        {
            if (pItem.transformEnabled && (pItem.transformMatrix != null || pItem.color != null || pItem.blendMode != null))
            {
                if (pItem.transformMatrix != null)
                {
                    _transformBuffer.fillRect(_transformBuffer.rect, 0);
                    _destPoint.x = 0;
                    _destPoint.y = 0;
                    _transformBuffer.copyPixels(pFrameData.asset, pFrameData.source, _destPoint);
                    _destMatrix.copyFrom(pItem.transformMatrix);
                    _destMatrix.tx += pX;
                    _destMatrix.ty += pY;
                    _buffer.drawWithQuality(_transformBuffer, _destMatrix, pItem.color, pItem.blendMode, null, pItem.transformSmooth, (pItem.quality != null) ? pItem.quality : StageQuality.LOW);
                }
                else
                {
                    _destMatrix.identity();
                    _destMatrix.tx = pX - pFrameData.source.x;
                    _destMatrix.ty = pY - pFrameData.source.y;
                    _sourceRect.x = pX;
                    _sourceRect.y = pY;
                    _sourceRect.width = pFrameData.source.width;
                    _sourceRect.height = pFrameData.source.height;
                    _buffer.drawWithQuality(pFrameData.asset, _destMatrix, pItem.color, pItem.blendMode, _sourceRect, false, (pItem.quality != null) ? pItem.quality : StageQuality.LOW);
                }
            }
            else
            {
                _destPoint.x = pX;
                _destPoint.y = pY;
                _buffer.copyPixels(pFrameData.asset, pFrameData.source, _destPoint);
            }
        }
        else
        {
            _destMatrix.identity();
            _destMatrix.tx = pX;
            _destMatrix.ty = pY;
            //_buffer.drawWithQuality(pFrameData.drawable,_destMatrix,pItem.color,pItem.blendMode,pFrameData.source,false,pItem.quality?pItem.quality:StageQuality.LOW);
            _buffer.drawWithQuality(pFrameData.drawable, _destMatrix, pItem.color, pItem.blendMode, null, false, (pItem.quality != null ) ? pItem.quality : StageQuality.LOW);
        }
    }
    
    private function get_scale() : Float
    {
        return _scale;
    }
    
    private function set_scale(value : Float) : Float
    {
        _scale = value;
        _width = Std.int(_originalWidth / _scale);
        _height = Std.int(_originalHeight / _scale);
        
        _rendering = new BitmapData(_width, _height, false, _backgroundColor);
        _bufferRect = _rendering.rect;
        _buffer = _rendering.clone();
        _transformBuffer = new BitmapData(_width, _height, true, 0);
        _container.bitmapData = _rendering;
        _container.scaleX = _container.scaleY = _scale;
        camera.setDimensions(_width, _height);
        return value;
    }
    
    public function createEmptyBitmap(pColor : Int = 0) : BitmapData
    {
        return new BitmapData(_buffer.width, _buffer.height, _buffer.transparent, pColor);
    }
    
    private function get_renderingWidth() : Int
    {
        return _width;
    }
    
    private function get_renderingHeight() : Int
    {
        return _height;
    }
}

