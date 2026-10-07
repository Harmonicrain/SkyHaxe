package com.sulake.habbo.ui.widget.roomchat.style
;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window._enum.WindowParam;

     class ChatBubbleStyle 
    {
        var _styleId:Int = 0;
        var _styleName:String;
        var _isSystemStyle:Bool = false;
        var _isStaffOverrideable:Bool = false;
        var _normalLayout:IRegionWindow;
        var _whisperLayout:IRegionWindow;
        var _shoutLayout:IRegionWindow;
        var _leftBitmapData:BitmapData;
        var _leftColorBitmapData:BitmapData;
        var _middleBitmapData:BitmapData;
        var _rightBitmapData:BitmapData;
        var _pointerBitmapData:BitmapData;
        var _selectorPreviewIconBitmapData:BitmapData;

        public function new(k:IAssetLibrary, _arg_2:IHabboWindowManager, _arg_3:com.sulake.core.utils.xml.XML)
        {
            this._styleId = ASCompat.toInt(_arg_3.attribute("id").at(0));
            this._styleName = ASCompat.xmlToString(_arg_3.attribute("name").at(0));
            this._isSystemStyle = _arg_3.attribute("systemstyle").at(0) != null;
            this._isStaffOverrideable = _arg_3.attribute("staffoverride").at(0) != null;
            var _local_4= _arg_3.child("layouts").at(0);
            var _local_5= _arg_3.child("bitmaps").at(0);
            this._normalLayout = this._Str_16373(_arg_2, k, _Str_3690(_local_4, "speakLayout"));
            this._whisperLayout = this._Str_16373(_arg_2, k, _Str_3690(_local_4, "whisperLayout"));
            this._shoutLayout = this._Str_16373(_arg_2, k, _Str_3690(_local_4, "shoutLayout"));
            var _local_6= _Str_3690(_local_5, "leftBitmap");
            var _local_7= _Str_3690(_local_5, "leftColorBitmap");
            var _local_8= _Str_3690(_local_5, "middleBitmap");
            var _local_9= _Str_3690(_local_5, "rightBitmap");
            var _local_10= _Str_3690(_local_5, "pointerBitmap");
            if (ASCompat.stringAsBool(_local_6))
            {
                this._leftBitmapData = this._Str_8638(_local_6, k);
            }
            if (ASCompat.stringAsBool(_local_7))
            {
                this._leftColorBitmapData = this._Str_8638(_local_7, k);
            }
            if (ASCompat.stringAsBool(_local_8))
            {
                this._middleBitmapData = this._Str_8638(_local_8, k);
            }
            if (ASCompat.stringAsBool(_local_9))
            {
                this._rightBitmapData = this._Str_8638(_local_9, k);
            }
            if (ASCompat.stringAsBool(_local_10))
            {
                this._pointerBitmapData = this._Str_8638(_local_10, k);
            }
            var _local_11= _Str_3690(_local_5, "previewIconBitmap");
            if (ASCompat.stringAsBool(_local_11))
            {
                this._selectorPreviewIconBitmapData = this._Str_8638(_local_11, k);
            }
        }

        static function _Str_3690(k:com.sulake.core.utils.xml.XML, _arg_2:String):String
        {
            var _local_3= k.child(_arg_2);
            if (_local_3.length() < 1)
            {
                return null;
            }
            var _local_4= new com.sulake.core.utils.xml.XML(_local_3.at(0)).attribute("assetId");
            if (_local_4.length() < 1)
            {
                return null;
            }
            return ASCompat.xmlToString(_local_4.at(0));
        }


        public var _Str_14292(get,never):IRegionWindow;
public function  get__Str_14292():IRegionWindow
        {
            return this._normalLayout;
        }

        public var whisperLayout(get,never):IRegionWindow;
public function  get_whisperLayout():IRegionWindow
        {
            return this._whisperLayout;
        }

        public var shoutLayout(get,never):IRegionWindow;
public function  get_shoutLayout():IRegionWindow
        {
            return this._shoutLayout;
        }

        public var _Str_13046(get,never):BitmapData;
public function  get__Str_13046():BitmapData
        {
            return this._leftBitmapData;
        }

        public var _Str_20211(get,never):BitmapData;
public function  get__Str_20211():BitmapData
        {
            return this._leftColorBitmapData;
        }

        public var _Str_7450(get,never):BitmapData;
public function  get__Str_7450():BitmapData
        {
            return this._middleBitmapData;
        }

        public var _Str_14107(get,never):BitmapData;
public function  get__Str_14107():BitmapData
        {
            return this._rightBitmapData;
        }

        public var pointerBitmapData(get,never):BitmapData;
public function  get_pointerBitmapData():BitmapData
        {
            return this._pointerBitmapData;
        }

        public var isSystemStyle(get,never):Bool;
public function  get_isSystemStyle():Bool
        {
            return this._isSystemStyle;
        }

        public var isStaffOverrideable(get,never):Bool;
public function  get_isStaffOverrideable():Bool
        {
            return this._isStaffOverrideable;
        }

        public var _Str_24719(get,never):BitmapData;
public function  get__Str_24719():BitmapData
        {
            return this._selectorPreviewIconBitmapData;
        }

        function _Str_16373(k:IHabboWindowManager, _arg_2:IAssetLibrary, _arg_3:String):IRegionWindow
        {
            if (_arg_3 == null)
            {
                return null;
            }
            var _local_4= _arg_2.getAssetByName(this._Str_17396((_arg_3 + "_xml")));
            var _local_5= Std.downcast(k.buildFromXML(((_local_4.content : com.sulake.core.utils.xml.XML) ), 1) , IRegionWindow);
            _local_5.tags.push("roomchat_bubble");
            _local_5.x = 0;
            _local_5.y = 0;
            _local_5.width = 0;
            _local_5.background = true;
            _local_5.mouseThreshold = 0;
            _local_5.setParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING, true);
            return _local_5;
        }

        function _Str_17396(k:String):String
        {
            var _local_2= ((("roomchat_styles_" + this._styleName) + "_") + k);
            return _local_2;
        }

        function _Str_8638(k:String, _arg_2:IAssetLibrary):BitmapData
        {
            var _local_3= _arg_2.getAssetByName(this._Str_17396(k));
            if (_local_3 != null)
            {
                return cast(_local_3.content, BitmapData);
            }
            throw new ASError(("Configured bitmapdata asset missing for chat bubble style: " + this._Str_17396(k)));
        }
    }

