package com.sulake.core.window.graphics.renderer
;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import com.sulake.core.window.utils.TextStyleManager;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.utils.ITextFieldContainer;
    import com.sulake.core.window.components.ITextWindow;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

     class TextSkinRenderer extends SkinRenderer 
    {
        static final _Str_4005:ColorTransform = new ColorTransform(0, 0, 0, 1, 0xFF, 0xFF, 0xFF, 0);

        var _matrix:Matrix;

        public function new(k:String)
        {
            super(k);
            this._matrix = new Matrix();
        }

        override public function parse(k:IAsset, _arg_2:com.sulake.core.utils.xml.XMLList, _arg_3:IAssetLibrary)
        {
            var _local_4:String = Std.string(k.content);
            TextStyleManager.setStyles(TextStyleManager.parseCSS(_local_4));
        }

        override public function draw(k:IWindow, _arg_2:BitmapData, _arg_3:Rectangle, _arg_4:UInt, _arg_5:Bool)
        {
            var _local_6:ITextFieldContainer = null;
            var _local_7:ITextWindow = null;
            var _local_8:String = null;
            var _local_9:TextField = null;
            var _local_10:ColorTransform = null;
            var _local_11:ASObject = null;
            if (_arg_2 != null)
            {
                _local_6 = cast(k, ITextFieldContainer);
                _local_7 = cast(k, ITextWindow);
                _local_8 = _local_7.autoSize;
                _local_9 = _local_6.textField;
                this._matrix.tx = _local_6.margins.left;
                this._matrix.ty = _local_6.margins.top;
                if (_local_8 == TextFieldAutoSize.RIGHT)
                {
                    this._matrix.tx = Math.ffloor((k.width - _local_9.width));
                }
                else
                {
                    if (_local_8 == TextFieldAutoSize.CENTER)
                    {
                        this._matrix.tx = Math.ffloor(((k.width / 2) - (_local_9.width / 2)));
                    }
                }
                if ((ASCompat.toInt(_local_7.etchingColor )& ASCompat.toInt(0xFF000000)) != 0)
                {
                    _Str_4005.redOffset = ((ASCompat.toInt(_local_7.etchingColor )>> 16) & 0xFF);
                    _Str_4005.greenOffset = ((ASCompat.toInt(_local_7.etchingColor )>> 8) & 0xFF);
                    _Str_4005.blueOffset = (ASCompat.toInt(_local_7.etchingColor )& 0xFF);
                    _Str_4005.alphaMultiplier = (((ASCompat.toInt(_local_7.etchingColor )>> 24) & 0xFF) / 0xFF);
                    _local_11 = SkinRenderer._Str_3766[_local_7.etchingPosition];
                    if (_local_11 != null)
                    {
                        this._matrix.tx = ASCompat.toNumber(this._matrix.tx + _local_11.x);
                        this._matrix.ty = ASCompat.toNumber(this._matrix.ty + _local_11.y);
                        _arg_2.draw(_local_9, this._matrix, _Str_4005, null, null, false);
                        this._matrix.tx = ASCompat.toNumber(this._matrix.tx - ASCompat.toNumber(_local_11.x));
                        this._matrix.ty = ASCompat.toNumber(this._matrix.ty - ASCompat.toNumber(_local_11.y));
                    }
                }
                if (k.dynamicStyleColor != null)
                {
                    _local_10 = k.dynamicStyleColor;
                }
                _arg_2.draw(_local_9, this._matrix, _local_10, null, null, false);
            }
        }

        override public function isStateDrawable(k:UInt):Bool
        {
            return k == 0;
        }
    }

