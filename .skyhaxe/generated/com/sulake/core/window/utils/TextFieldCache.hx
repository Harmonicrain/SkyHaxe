package com.sulake.core.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.FontStyle;
    import flash.text.AntiAliasType;
    import flash.text.TextFieldAutoSize;
    import com.sulake.core.utils.FontEnum;

     class TextFieldCache implements IDisposable 
    {
        static var _textFieldCache:Map = new Map();
        static var _Str_1229:TextFieldCache = Type.createInstance(TextFieldCache, []);

        var _disposed:Bool = false;

        public function new()
        {
            if (_Str_1229 == null)
            {
                TextStyleManager.events.addEventListener(Event.CHANGE, this.onTextStyleChanged);
            }
        }

        public static function getTextFieldByStyle(k:TextStyle):TextField
        {
            var _local_2:TextField = _textFieldCache.getValue(k.name);
            if (_local_2 != null)
            {
                return _local_2;
            }
            _local_2 = new TextField();
            var _local_3= _local_2.defaultTextFormat;
            if (k == null)
            {
                k = TextStyleManager.getStyle(TextStyleManager.REGULAR);
            }
            _local_3.font = k.fontFamily;
            _local_3.size = k.fontSize;
            _local_3.color = k.color;
            _local_3.bold = ((k.fontWeight == FontStyle.BOLD) ? true : null);
            _local_3.italic = ((k.fontStyle == FontStyle.ITALIC) ? true : null);
            _local_3.underline = ((k.textDecoration == TextStyle.UNDERLINE) ? true : null);
            _local_3.indent = k.textIndent;
            _local_3.leading = k.leading;
            _local_3.kerning = k.kerning;
            _local_3.letterSpacing = k.letterSpacing;
            _local_2.antiAliasType = ((k.antiAliasType == AntiAliasType.ADVANCED) ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL);
            _local_2.sharpness = (k.sharpness ? ASCompat.asInt(k.sharpness ) : 0);
            _local_2.thickness = (k.thickness ? ASCompat.asInt(k.thickness ) : 0);
            if (!ASCompat.stringAsBool(k.fontWeight))
            {
                _local_3.bold = false;
            }
            if (!ASCompat.stringAsBool(k.fontStyle))
            {
                _local_3.italic = false;
            }
            if (!ASCompat.stringAsBool(k.textDecoration))
            {
                _local_3.underline = false;
            }
            if (!k.textIndent)
            {
                _local_3.indent = 0;
            }
            if (!k.leading)
            {
                _local_3.leading = 0;
            }
            if (!k.kerning)
            {
                _local_3.kerning = false;
            }
            if (!k.letterSpacing)
            {
                _local_3.letterSpacing = 0;
            }
            if (!ASCompat.stringAsBool(k.antiAliasType))
            {
                _local_2.antiAliasType = AntiAliasType.NORMAL;
            }
            _local_2.autoSize = TextFieldAutoSize.LEFT;
            _local_2.setTextFormat(_local_3);
            _local_2.embedFonts = FontEnum.isEmbeddedFont(_local_3.font);
            _local_2.defaultTextFormat = _local_3;
            _textFieldCache.setProperty(k.name, _local_2);
            return _local_2;
        }

        public static function getTextFieldByStyleName(k:String):TextField
        {
            var _local_2= TextStyleManager.getStyle(k);
            if (_local_2 == null)
            {
                return null;
            }
            return getTextFieldByStyle(_local_2);
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            TextStyleManager.events.removeEventListener(Event.CHANGE, this.onTextStyleChanged);
            _textFieldCache.reset();
            _Str_1229 = null;
            this._disposed = true;
        }

        function onTextStyleChanged(k:Event)
        {
            _textFieldCache.reset();
        }
    }

