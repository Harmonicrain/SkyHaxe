package com.sulake.core.window.graphics.renderer
;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import com.sulake.core.window.graphics.BitmapSkinParser;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;

     class BitmapSkinRenderer extends SkinRenderer implements ISkinRenderer 
    {
        static final _Str_2681:Rectangle = new Rectangle();
        static final _Str_17316:Point = new Point();

        var _Str_7047:ASDictionary<ASAny,ASAny>;
        var _Str_4651:Matrix;
        var _Str_591:ColorTransform;

        public function new(k:String)
        {
            super(k);
            this._Str_7047 = new ASDictionary<ASAny,ASAny>(false);
            this._Str_4651 = new Matrix();
            this._Str_591 = new ColorTransform();
        }

        override public function parse(k:IAsset, _arg_2:com.sulake.core.utils.xml.XMLList, _arg_3:IAssetLibrary)
        {
            BitmapSkinParser._Str_24598(((k.content : com.sulake.core.utils.xml.XML) ), _arg_2, this, name, _arg_3);
        }

        override public function dispose()
        {
var k:String  = null;            var k:String = null;
            var _local_2:BitmapData = null;
            if (!disposed)
            {
                super.dispose();
                this._Str_4651 = null;
                this._Str_591 = null;
                final _iter_ = this._Str_7047; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    _local_2 = ASCompat.dynamicAs(this._Str_7047[k] , BitmapData);
                    _local_2.dispose();
                    this._Str_7047.remove(k);
                }
                this._Str_7047 = null;
            }
        }

        override public function isStateDrawable(k:UInt):Bool
        {
            return !(_Str_5217[k] == null);
        }

        override public function draw(k:IWindow, _arg_2:BitmapData, _arg_3:Rectangle, _arg_4:UInt, _arg_5:Bool)
        {
            var _local_8:UInt = 0;
            var _local_9:SkinLayoutEntity = null;
            var _local_10:ISkinTemplateEntity = null;
            var _local_11 = false;
            var _local_12 = false;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = false;
            var _local_16:UInt = 0;
            var _local_17:BitmapData = null;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20 = 0;
            var _local_21 = 0;
            var _local_22 = 0;
            var _local_23 = 0;
            var _local_24:Point = null;
            var _local_25:Rectangle = null;
            var _local_26:Rectangle = null;
            var _local_27:UInt = 0;
            var _local_28 = 0;
            var _local_29:BitmapData = null;
            var _local_30 = false;
            var _local_31 = false;
            var _local_6:ISkinLayout = _Str_5580[_arg_4];
            var _local_7:ISkinTemplate = _Str_5217[_arg_4];
            if (_local_6 == null)
            {
                _local_6 = _Str_5580[WindowState.DEFAULT];
                _local_7 = _Str_5217[WindowState.DEFAULT];
            }
            _local_8 = _local_6.numChildren;
            if (((!(_local_6 == null)) && (_local_8 > 0)))
            {
                _local_13 = Std.int(_arg_3.width - _local_6.width);
                _local_14 = Std.int(_arg_3.height - _local_6.height);
                _local_15 = ((!k.background) && ((ASCompat.toInt(k.color )& 0xFFFFFF) < 0xFFFFFF));
                if (_local_15)
                {
                    this._Str_591.redMultiplier = (((ASCompat.toInt(k.color )& 0xFF0000) >> 16) / 0xFF);
                    this._Str_591.greenMultiplier = (((ASCompat.toInt(k.color )& 0xFF00) >> 8) / 0xFF);
                    this._Str_591.blueMultiplier = ((ASCompat.toInt(k.color )& 0xFF) / 0xFF);
                    this._Str_591.alphaMultiplier = 1;
                }
                _local_16 = 0;
                while (_local_16 < _local_8)
                {
                    _local_9 = Std.downcast(_local_6.getChildAt(ASCompat.toInt(_local_16)) , SkinLayoutEntity);
                    _local_10 = Std.downcast(_local_7.getChildByName(_local_9.name) , ISkinTemplateEntity);
                    if (_local_10 != null)
                    {
                        _local_17 = this._Str_21725(_local_7, _local_9.name);
                        _local_30 = false;
                        if (((!k.background) && _local_9.colorize && (_local_9.colorizeMethod == SkinLayoutEntity.COLORIZE_METHOD_HSV_LAYER)))
                        {
                            _local_17 = _local_17.clone();
                            _local_30 = true;
                            HsvLayerColor.configureTransform(this._Str_591, k.color, _local_9.shade);
                            _local_17.colorTransform(_local_17.rect, this._Str_591);
                            _local_31 = true;
                        }
                        else
                        {
                            if ((_local_15 && _local_9.colorize))
                            {
                                if (_local_31)
                                {
                                    this._Str_591.redMultiplier = (((ASCompat.toInt(k.color )& 0xFF0000) >> 16) / 0xFF);
                                    this._Str_591.greenMultiplier = (((ASCompat.toInt(k.color )& 0xFF00) >> 8) / 0xFF);
                                    this._Str_591.blueMultiplier = ((ASCompat.toInt(k.color )& 0xFF) / 0xFF);
                                    this._Str_591.alphaMultiplier = 1;
                                    _local_31 = false;
                                }
                                _local_17 = _local_17.clone();
                                _local_30 = true;
                                _local_17.colorTransform(_local_17.rect, this._Str_591);
                            }
                        }
                        _local_11 = false;
                        _local_12 = false;
                        _Str_2681.x = (_local_9.region.x + _arg_3.x);
                        _Str_2681.y = (_local_9.region.y + _arg_3.y);
                        _Str_2681.width = _local_9.region.width;
                        _Str_2681.height = _local_9.region.height;
                        if (_local_9.scaleH == SkinLayoutEntity.SCALE_TYPE_MOVE)
                        {
                            _Str_2681.x = (_Str_2681.x + _local_13);
                        }
                        else
                        {
                            if (_local_9.scaleH == SkinLayoutEntity.SCALE_TYPE_STRECH)
                            {
                                _local_11 = true;
                                _Str_2681.right = (_Str_2681.right + _local_13);
                                if (_Str_2681.width < 1) break;
                            }
                            else
                            {
                                if (_local_9.scaleH == SkinLayoutEntity.SCALE_TYPE_TILED)
                                {
                                    _local_11 = true;
                                    _Str_2681.right = (_Str_2681.right + _local_13);
                                    if (_Str_2681.width < 1) break;
                                }
                                else
                                {
                                    if (_local_9.scaleH == SkinLayoutEntity.SCALE_TYPE_CENTER)
                                    {
                                        _Str_2681.x = ((_arg_3.width / 2) - (_Str_2681.width / 2));
                                    }
                                }
                            }
                        }
                        if (_local_9.scaleV == SkinLayoutEntity.SCALE_TYPE_MOVE)
                        {
                            _Str_2681.y = (_Str_2681.y + _local_14);
                        }
                        else
                        {
                            if (_local_9.scaleV == SkinLayoutEntity.SCALE_TYPE_STRECH)
                            {
                                _local_12 = true;
                                _Str_2681.bottom = (_Str_2681.bottom + _local_14);
                                if (_Str_2681.height < 1) break;
                            }
                            else
                            {
                                if (_local_9.scaleV == SkinLayoutEntity.SCALE_TYPE_TILED)
                                {
                                    _local_12 = true;
                                    _Str_2681.bottom = (_Str_2681.bottom + _local_14);
                                    if (_Str_2681.height < 1) break;
                                }
                                else
                                {
                                    if (_local_9.scaleV == SkinLayoutEntity.SCALE_TYPE_CENTER)
                                    {
                                        _Str_2681.y = ((_arg_3.height / 2) - (_Str_2681.height / 2));
                                    }
                                }
                            }
                        }
                        if (((!_local_11) && (!_local_12)))
                        {
                            _arg_2.copyPixels(_local_17, _local_17.rect, _Str_2681.topLeft, null, null, true);
                        }
                        else
                        {
                            if (((_local_9.scaleV == SkinLayoutEntity.SCALE_TYPE_TILED) || (_local_9.scaleH == SkinLayoutEntity.SCALE_TYPE_TILED)))
                            {
                                _local_18 = _local_17.width;
                                _local_19 = _local_17.height;
                                _local_20 = Std.int(_Str_2681.width / _local_18);
                                _local_21 = Std.int(_Str_2681.height / _local_19);
                                _local_22 = Std.int(_Str_2681.width % _local_18);
                                _local_23 = Std.int(_Str_2681.height % _local_19);
                                _local_24 = new Point(_Str_2681.x, _Str_2681.y);
                                _local_25 = new Rectangle(0, 0, _local_22, _local_17.height);
                                _local_26 = new Rectangle(0, 0, _local_17.width, _local_23);
                                _local_27 = 0;
                                while (_local_27 < (_local_21 : UInt))
                                {
                                    _local_24.x = _Str_2681.x;
                                    _local_28 = 0;
                                    while (_local_28 < _local_20)
                                    {
                                        _arg_2.copyPixels(_local_17, _local_17.rect, _local_24, null, null, true);
                                        _local_24.x = (_local_24.x + _local_18);
                                        _local_28++;
                                    }
                                    if (_local_22 > 0)
                                    {
                                        _arg_2.copyPixels(_local_17, _local_25, _local_24, null, null, true);
                                    }
                                    _local_24.y = (_local_24.y + _local_19);
                                    _local_27++;
                                }
                                if (_local_23 > 0)
                                {
                                    _local_24.x = _Str_2681.x;
                                    _local_27 = 0;
                                    while (_local_27 < (_local_20 : UInt))
                                    {
                                        _arg_2.copyPixels(_local_17, _local_26, _local_24, null, null, true);
                                        _local_24.x = (_local_24.x + _local_18);
                                        _local_27++;
                                    }
                                }
                            }
                            else
                            {
                                if (((_local_17.width == 1) && (_local_17.height == 1)))
                                {
                                    this._Str_4651.a = _Str_2681.width;
                                    this._Str_4651.d = _Str_2681.height;
                                    this._Str_4651.tx = _Str_2681.x;
                                    this._Str_4651.ty = _Str_2681.y;
                                    _arg_2.draw(_local_17, this._Str_4651);
                                }
                                else
                                {
                                    this._Str_4651.a = (_Str_2681.width / _local_17.width);
                                    this._Str_4651.d = (_Str_2681.height / _local_17.height);
                                    this._Str_4651.tx = 0;
                                    this._Str_4651.ty = 0;
                                    _local_29 = new BitmapData(Std.int(_Str_2681.width), Std.int(_Str_2681.height), true, 0);
                                    _local_29.draw(_local_17, this._Str_4651);
                                    _arg_2.copyPixels(_local_29, _local_29.rect, _Str_2681.topLeft, null, null, true);
                                    _local_29.dispose();
                                }
                            }
                        }
                        if (_local_30)
                        {
                            _local_17.dispose();
                        }
                    }
                    _local_16++;
                }
            }
        }

        function _Str_25947(k:BitmapData, _arg_2:Rectangle, _arg_3:ISkinLayout, _arg_4:SkinLayoutEntity, _arg_5:ISkinTemplate, _arg_6:ISkinTemplateEntity)
        {
            var _local_8:BitmapData = null;
            var _local_7= _arg_4.region.clone();
            _local_7.x = (_local_7.x + _arg_2.x);
            _local_7.y = (_local_7.y + _arg_2.y);
            switch (_arg_6.type)
            {
                case "bitmap":
                    _local_8 = this._Str_21725(_arg_5, _arg_4.name);
                    if (_arg_4.scaleH == SkinLayoutEntity.SCALE_TYPE_MOVE)
                    {
                        _local_7.x = (_local_7.x + (_arg_2.width - _arg_3.width));
                    }
                    if (_arg_4.scaleV == SkinLayoutEntity.SCALE_TYPE_MOVE)
                    {
                        _local_7.y = (_local_7.y + (_arg_2.height - _arg_3.height));
                    }
                    k.copyPixels(_local_8, _local_8.rect, _local_7.topLeft, null, null, true);
                    return;
                case "fill":
                    k.fillRect(_local_7, _arg_4.color);
                    return;
            }
        }

        function _Str_21725(k:ISkinTemplate, _arg_2:String):BitmapData
        {
            var _local_5:ISkinTemplateEntity = null;
            var _local_6:BitmapData = null;
            var _local_3= ((_arg_2 + "@") + k.name);
            var _local_4:BitmapData = this._Str_7047[_local_3];
            if (_local_4 == null)
            {
                _local_5 = Std.downcast(k.getChildByName(_arg_2) , ISkinTemplateEntity);
                if (_local_5 == null)
                {
                    throw new ASError((("Template entity" + _arg_2) + "not found!"));
                }
                _local_6 = ASCompat.dynamicAs(k.asset.content , BitmapData);
                if (_local_6 == null)
                {
                    throw new ASError((("Asset " + k.asset) + " not found!"));
                }
                _local_4 = new TrackedBitmapData(this, Std.int(_local_5.region.width), Std.int(_local_5.region.height), true);
                _local_4.copyPixels(_local_6, _local_5.region, _Str_17316);
                this._Str_7047[_local_3] = _local_4;
            }
            return _local_4;
        }

        function drawBorders(k:BitmapData, _arg_2:Rectangle, _arg_3:UInt)
        {
            var _local_4 = 0;
            var _local_5= Std.int(_arg_2.bottom - 1);
            _local_4 = Std.int(_arg_2.left);
            while (_local_4 < (_arg_2.right - 1))
            {
                k.setPixel32(_local_4, 0, _arg_3);
                k.setPixel32(_local_4, _local_5, _arg_3);
                _local_4++;
            }
            _local_5 = Std.int(_arg_2.top);
            while (_local_5 < (_arg_2.bottom - 1))
            {
                k.setPixel32(0, _local_5, _arg_3);
                k.setPixel32(_local_4, _local_5, _arg_3);
                _local_5++;
            }
        }
    }

