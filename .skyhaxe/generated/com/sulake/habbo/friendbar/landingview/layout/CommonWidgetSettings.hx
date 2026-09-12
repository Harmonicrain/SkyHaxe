package com.sulake.habbo.friendbar.landingview.layout
;
    import com.sulake.core.runtime.IHabboConfigurationManager;

     class CommonWidgetSettings
    {
        static inline final _Str_16303:UInt = 0xFF000000;
        static inline final _Str_18953:UInt = 0xFFFFFFFF;
        static inline final BOTTOM= "bottom";
        static inline final LANDING_VIEW_COMMON_TEXTCOLOR= "landing.view.common.textcolor";
        static inline final LANDING_VIEW_COMMON_ETCHINGCOLOR= "landing.view.common.etchingcolor";
        static inline final LANDING_VIEW_COMMON_ETCHINGPOSITION= "landing.view.common.etchingposition";

        var _textColor:UInt = 0xFF000000;
        var _etchingColor:UInt = 0xFFFFFFFF;
        var _etchingPosition:String = "bottom";

        public function new(k:IHabboConfigurationManager)
        {
            if (k.getProperty(LANDING_VIEW_COMMON_TEXTCOLOR) != "")
            {
                this._textColor = ASCompat.parseInt(k.getProperty(LANDING_VIEW_COMMON_TEXTCOLOR), 16);
            }
            if (k.getProperty(LANDING_VIEW_COMMON_ETCHINGCOLOR) != "")
            {
                this._etchingColor = ASCompat.parseInt(k.getProperty(LANDING_VIEW_COMMON_ETCHINGCOLOR), 16);
            }
            if (k.getProperty(LANDING_VIEW_COMMON_ETCHINGPOSITION) != "")
            {
                this._etchingPosition = k.getProperty(LANDING_VIEW_COMMON_ETCHINGPOSITION);
            }
        }

        public var isTextColorSet(get,never):Bool;
public function  get_isTextColorSet():Bool
        {
            return !(this._textColor == _Str_16303);
        }

        public var isEtchingColorSet(get,never):Bool;
public function  get_isEtchingColorSet():Bool
        {
            return !(this._etchingColor == _Str_18953);
        }

        public var isEtchingPositionSet(get,never):Bool;
public function  get_isEtchingPositionSet():Bool
        {
            return !(this._etchingPosition == BOTTOM);
        }

        public var textColor(get,never):UInt;
public function  get_textColor():UInt
        {
            return this._textColor;
        }

        public var etchingColor(get,never):UInt;
public function  get_etchingColor():UInt
        {
            return this._etchingColor;
        }

        public var etchingPosition(get,never):String;
public function  get_etchingPosition():String
        {
            return this._etchingPosition;
        }
    }

