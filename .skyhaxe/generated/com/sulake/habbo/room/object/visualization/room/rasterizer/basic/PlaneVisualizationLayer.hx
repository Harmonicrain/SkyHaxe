package com.sulake.habbo.room.object.visualization.room.rasterizer.basic
;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

     class PlaneVisualizationLayer implements IDisposable 
    {
        public static inline final DEFAULT_OFFSET= 0;
        public static inline final ALIGN_TOP= 1;
        public static inline final ALIGN_BOTTOM= 2;
        public static final ALIGN_DEFAULT:Int = ALIGN_TOP;//1

        var _material:PlaneMaterial = null;
        var _color:UInt = 0;
        var _offset:Int = 0;
        var _align:Int = 1;
        var _bitmapData:BitmapData = null;
        var _isDisposed:Bool = false;

        public function new(k:PlaneMaterial, _arg_2:UInt, _arg_3:Int, _arg_4:Int=0)
        {
            this._material = k;
            this._offset = _arg_4;
            this._align = _arg_3;
            this._color = _arg_2;
        }

        public var offset(get,never):Int;
public function  get_offset():Int
        {
            return this._offset;
        }

        public var align(get,never):Int;
public function  get_align():Int
        {
            return this._align;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._material = null;
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
        }

        public function clearCache()
        {
            if (this._bitmapData != null)
            {
                this._bitmapData.dispose();
                this._bitmapData = null;
            }
        }

        public function render(canvas:BitmapData, width:Int, height:Int, normal:IVector3d, useTexture:Bool, offsetX:Int, offsetY:Int):BitmapData
        {
            var tR = Math.NaN;
            var tG = Math.NaN;
            var tB = Math.NaN;
            var ctf:ColorTransform = null;
            var r:UInt = (ASCompat.toInt(this._color )>> 16);
            var g:UInt = ((ASCompat.toInt(this._color )>> 8) & 0xFF);
            var b:UInt = (ASCompat.toInt(this._color )& 0xFF);
            var hasColor = false;
            if ((((r < 0xFF) || (g < 0xFF)) || (b < 0xFF)))
            {
                hasColor = true;
            }
            if ((((canvas == null) || (!(canvas.width == width))) || (!(canvas.height == height))))
            {
                canvas = null;
            }
            var bitmapData:BitmapData = null;
            if (this._material != null)
            {
                if (hasColor)
                {
                    bitmapData = this._material.render(null, width, height, normal, useTexture, offsetX, (offsetY + this.offset), (this.align == ALIGN_TOP));
                }
                else
                {
                    bitmapData = this._material.render(canvas, width, height, normal, useTexture, offsetX, (offsetY + this.offset), (this.align == ALIGN_TOP));
                }
                if (((!(bitmapData == null)) && (!(bitmapData == canvas))))
                {
                    if (this._bitmapData != null)
                    {
                        this._bitmapData.dispose();
                    }
                    try
                    {
                        this._bitmapData = bitmapData.clone();
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                        if (_bitmapData != null)
                        {
                            _bitmapData.dispose();
                        }
                        _bitmapData = null;
                        return null;
                    }
 }                    bitmapData = this._bitmapData;
                }
            }
            else
            {
                if (canvas == null)
                {
                    if ((((!(this._bitmapData == null)) && (this._bitmapData.width == width)) && (this._bitmapData.height == height)))
                    {
                        return this._bitmapData;
                    }
                    if (this._bitmapData != null)
                    {
                        this._bitmapData.dispose();
                    }
                    this._bitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
                    bitmapData = this._bitmapData;
                }
                else
                {
                    canvas.fillRect(canvas.rect, 0xFFFFFFFF);
                    bitmapData = canvas;
                }
            }
            if (bitmapData != null)
            {
                if (hasColor)
                {
                    tR = (r / 0xFF);
                    tG = (g / 0xFF);
                    tB = (b / 0xFF);
                    ctf = new ColorTransform(tR, tG, tB);
                    bitmapData.colorTransform(bitmapData.rect, ctf);
                    if (((!(canvas == null)) && (!(bitmapData == canvas))))
                    {
                        canvas.copyPixels(bitmapData, bitmapData.rect, new Point(0, 0), null, null, true);
                        bitmapData = canvas;
                    }
                }
            }
            return bitmapData;
        }

        public function material():PlaneMaterial
        {
            return this._material;
        }

        public function getColor():UInt
        {
            return this._color;
        }
    }

