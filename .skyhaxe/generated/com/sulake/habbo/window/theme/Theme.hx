package com.sulake.habbo.window.theme
;
    import com.sulake.core.window.theme.PropertyMap;

     class Theme 
    {
        public static inline final NONE= "None";
        public static inline final ICON= "Icon";
        public static inline final LEGACY_BORDER= "Legacy border";
        public static inline final VOLTER= "Volter";
        public static inline final UBUNTU= "Ubuntu";
        public static inline final ILLUMINA_LIGHT= "Illumina Light";
        public static inline final ILLUMINA_DARK= "Illumina Dark";
        public static inline final LEADERBOARD= "Leaderboard";

        var _name:String;
        var _isReal:Bool = false;
        var _baseStyle:UInt = 0;
        var _styleCount:UInt = 0;
        var _propertyDefaults:PropertyMap;

        public function new(name:String, isReal:Bool, baseStyle:UInt, styleCount:UInt, propertyDefaults:PropertyMap)
        {
            this._name = name;
            this._isReal = isReal;
            this._baseStyle = baseStyle;
            this._styleCount = styleCount;
            this._propertyDefaults = propertyDefaults;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var isReal(get,never):Bool;
public function  get_isReal():Bool
        {
            return this._isReal;
        }

        public var baseStyle(get,never):UInt;
public function  get_baseStyle():UInt
        {
            return this._baseStyle;
        }

        public var styleCount(get,never):UInt;
public function  get_styleCount():UInt
        {
            return this._styleCount;
        }

        public var propertyDefaults(get,never):PropertyMap;
public function  get_propertyDefaults():PropertyMap
        {
            return this._propertyDefaults;
        }

        public function coversStyle(style:UInt):Bool
        {
            return (style >= this._baseStyle) && (style < (this._baseStyle + this._styleCount));
        }
    }

