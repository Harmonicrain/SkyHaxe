package com.sulake.habbo.notifications.singular
;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;

     class HabboNotificationItemStyle 
    {
        var _icon:BitmapData;
        var _disposeIcon:Bool = false;
        var _iconSrc:String;
        var _internalLink:String;
        var _iconAssetUri:String;
        var _customLayout:String;
        var _customView:String;
        var _extraData:ASObject;
        var _styleName:String;

        public function new(k:Map, _arg_2:BitmapData, _arg_3:String, _arg_4:Bool, _arg_5:String, _arg_6:ASObject=null, _arg_7:String=null)
        {
            this._iconAssetUri = _arg_3;
            if (((!(k == null)) && (_arg_3 == null)))
            {
                this._icon = k.getValue("icon");
                this._internalLink = k.getValue("internallink");
                this._customLayout = k.getValue("customlayout");
                this._customView = k.getValue("customview");
            }
            if (_arg_2 != null)
            {
                this._icon = _arg_2;
                this._disposeIcon = _arg_4;
            }
            else
            {
                this._disposeIcon = false;
            }
            this._iconSrc = _arg_5;
            this._extraData = _arg_6 == null ? {} : _arg_6;
            this._styleName = _arg_7;
        }

        public function dispose()
        {
            if ((this._disposeIcon && (!(this._icon == null))))
            {
                this._icon.dispose();
                this._icon = null;
            }
        }

        public var icon(get,never):BitmapData;
public function  get_icon():BitmapData
        {
            return this._icon;
        }

        
        public var internalLink(get,set):String;
public function  get_internalLink():String
        {
            return this._internalLink;
        }
public function  set_internalLink(k:String):String        {
            return this._internalLink = k;
        }

        public var _Str_25821(get,never):String;
public function  get__Str_25821():String
        {
            return this._iconSrc;
        }

        public var _Str_21712(get,never):String;
public function  get__Str_21712():String
        {
            return this._iconAssetUri;
        }

        public var customLayout(get,never):String;
public function  get_customLayout():String { return this._customLayout; }
        public var customView(get,never):String;
public function  get_customView():String { return this._customView; }
        public var extraData(get,never):ASObject;
public function  get_extraData():ASObject { return this._extraData; }
        public var styleName(get,never):String;
public function  get_styleName():String { return this._styleName; }
    }

