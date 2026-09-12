package com.sulake.habbo.ui.widget.roomchat.style
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.ui.widget.enums.ChatTypeEnum;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.display.BlendMode;
    import flash.geom.Matrix;

     class ChatBubbleFactory 
    {
        static inline final _Str_15957= 0;

        var _styles:Map;

        public function new(assets:IAssetLibrary, windowManager:IHabboWindowManager, config:com.sulake.core.utils.xml.XML)
        {
            var child:com.sulake.core.utils.xml.XML = null;
            var styleId = 0;
            var assetId:String = null;
            var configXmlAssetName:String = null;
            var configXml:com.sulake.core.utils.xml.XML = null;
            var style:ChatBubbleStyle = null;
            this._styles = new Map();
            final _iter_ = config.child("style"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
child  = _tmp_;
                styleId = ASCompat.toInt(child.attribute("id").at(0));
                assetId = ASCompat.xmlToString(child.attribute("assetId").at(0));
                configXmlAssetName = (("roomchat_styles_" + assetId) + "_style_xml");
                configXml = new com.sulake.core.utils.xml.XML(assets.getAssetByName(configXmlAssetName).content);
                try
                {
                    style = new ChatBubbleStyle(assets, windowManager, configXml);
                    this._styles.add(styleId, style);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([((("Error initializing chat style: " + Std.string(styleId)) + ", error message: ") + e.message)]);
                }
 }            }
        }

        public function _Str_25575(k:Int, _arg_2:Int):IRegionWindow
        {
            var _local_3= this._Str_12308(k);
            switch (_arg_2)
            {
                case ChatTypeEnum.SPEAK:
                    return cast(_local_3._Str_14292.clone(), IRegionWindow);
                case ChatTypeEnum.SHOUT:
                    if (_local_3.shoutLayout != null)
                    {
                        return cast(_local_3.shoutLayout.clone(), IRegionWindow);
                    }
                    return cast(_local_3._Str_14292.clone(), IRegionWindow);
                case ChatTypeEnum.WHISPER:
                    if (_local_3.whisperLayout != null)
                    {
                        return cast(_local_3.whisperLayout.clone(), IRegionWindow);
                    }
                    return cast(_local_3._Str_14292.clone(), IRegionWindow);
                default:
                    if (_local_3.whisperLayout != null)
                    {
                        return cast(_local_3.whisperLayout.clone(), IRegionWindow);
                    }
                    return cast(_local_3._Str_14292.clone(), IRegionWindow);
            }
        }

        public function _Str_23013(k:Int):BitmapData
        {
            return this._Str_12308(k).pointerBitmapData;
        }

        public function _Str_25059(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:UInt):BitmapData
        {
            var _local_12:UInt = 0;
            var _local_13:UInt = 0;
            var _local_14:UInt = 0;
            var _local_15 = 0;
            var _local_16 = 0;
            var _local_6= this._Str_12308(k);
            var _local_7 = 0;
            var _local_8= new Point();
            var _local_9= new BitmapData(((_local_6._Str_13046.width + _arg_3) + _local_6._Str_14107.width), _arg_4, true, 0);
            _local_7 = (_local_7 + _local_6._Str_13046.width);
            _local_9.copyPixels(_local_6._Str_13046, _local_6._Str_13046.rect, _local_8);
            if (_local_6._Str_20211 != null)
            {
                _local_12 = 232;
                _local_13 = 177;
                _local_14 = 55;
                if (_arg_5 != 0)
                {
                    _local_12 = ((ASCompat.toInt(_arg_5 )>> 16) & 0xFF);
                    _local_13 = ((ASCompat.toInt(_arg_5 )>> 8) & 0xFF);
                    _local_14 = ((ASCompat.toInt(_arg_5 )>> 0) & 0xFF);
                }
                _local_9.draw(_local_6._Str_20211, null, new ColorTransform((_local_12 / 0xFF), (_local_13 / 0xFF), (_local_14 / 0xFF)), BlendMode.DARKEN);
            }
            var _local_10= new Matrix();
            if (_local_6._Str_7450.width == 1)
            {
                _local_10.scale((_arg_3 / _local_6._Str_7450.width), 1);
                _local_10.translate(_local_7, 0);
                _local_9.draw(_local_6._Str_7450, _local_10);
            }
            else
            {
                _local_10.translate(_local_7, 0);
                _local_15 = Std.int((_arg_3 / _local_6._Str_7450.width) + 1);
                _local_16 = 0;
                while (_local_16 < _local_15)
                {
                    _local_9.draw(_local_6._Str_7450, _local_10);
                    _local_10.translate(_local_6._Str_7450.width, 0);
                    _local_16++;
                }
            }
            _local_7 = (_local_7 + _arg_3);
            _local_8.x = _local_7;
            _local_9.copyPixels(_local_6._Str_14107, _local_6._Str_14107.rect, _local_8);
            var _local_11= _local_6._Str_14107.rect.clone();
            _local_11.offsetPoint(_local_8);
            return _local_9;
        }

        public function getStyleIds():Array<ASAny>
        {
            return this._styles.getKeys();
        }

        public function _Str_25949():Array<ASAny>
        {
            var _local_2 = 0;
            var _local_3:ChatBubbleStyle = null;
            var k= new Array<ASAny>();
            final _iter_ = this.getStyleIds(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                _local_3 = this._styles.getValue(_local_2);
                if (((!_local_3.isSystemStyle) && (!_local_3.isStaffOverrideable)))
                {
                    k.push(_local_2);
                }
            }
            return k;
        }

        public function _Str_26286():Array<ASAny>
        {
            var _local_2 = 0;
            var _local_3:ChatBubbleStyle = null;
            var k= new Array<ASAny>();
            final _iter_ = this.getStyleIds(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                _local_3 = this._styles.getValue(_local_2);
                if (_local_3.isStaffOverrideable)
                {
                    k.push(_local_2);
                }
            }
            return k;
        }

        public function _Str_26232(k:Int):BitmapData
        {
            var _local_2= this._Str_12308(k);
            return _local_2._Str_24719;
        }

        public function _Str_24902(k:Int):Int
        {
            var _local_2= this._Str_12308(k);
            return _local_2._Str_7450.height;
        }

        function _Str_12308(k:Int):ChatBubbleStyle
        {
            if (!this._styles.hasKey(k))
            {
                k = _Str_15957;
            }
            return cast(this._styles.getValue(k), ChatBubbleStyle);
        }
    }

