package com.sulake.core.utils
;
    import flash.text.Font;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class FontEnum 
    {
        static final _systemFonts:Map = new Map();
        static final _embeddedFonts:Map = new Map();
        static var _init:Bool = false;


        public static function isSystemFont(font:String):Bool
        {
            return !(_systemFonts.getValue(font) == null);
        }

        public static function isEmbeddedFont(font:String):Bool
        {
            return !(_embeddedFonts.getValue(font) == null);
        }

        public static var systemFonts(get,never):Map;
public static function  get_systemFonts():Map
        {
            return _systemFonts;
        }

        public static var embeddedFonts(get,never):Map;
public static function  get_embeddedFonts():Map
        {
            return _embeddedFonts;
        }

        public static function registerFont(f:Class<Dynamic>):Font
        {
            var font:Font = null;
            Font.registerFont(f );
            var name= getQualifiedClassName(f);
            var allFonts= Font.enumerateFonts(false);
            var index= allFonts.length;
            while (index > 0)
            {
                font = allFonts[(index - 1)];
                if (getQualifiedClassName(font) == name)
                {
                    break;
                }
                index--;
            }
            _embeddedFonts.add(font.fontName, font);
            return font;
        }

        static function init()
        {
            var deviceFonts:Array<ASAny> = null;
            var embeddedFonts:Array<ASAny> = null;
            var font:Font = null;
            if (!_init)
            {
                deviceFonts = Font.enumerateFonts(true);
                embeddedFonts = Font.enumerateFonts(false);
                if (checkNullIteratee(deviceFonts)) for (_tmp_ in deviceFonts)
                {
font  = _tmp_;
                    if (embeddedFonts.indexOf(font) == -1)
                    {
                        _systemFonts.add(font.fontName, font);
                    }
                }
                _init = true;
            }
        }

        public static function refresh()
        {
var systemFont:Font = null, embeddedFont:Font = null, systemFonts:Array<ASAny>  = null, index = 0;			try
			{
systemFont;
embeddedFont;
systemFonts= Font.enumerateFonts(false);
index;
				while (index < systemFonts.length)
				{
					systemFont = systemFonts[index];
					embeddedFont = _embeddedFonts.getValue(systemFont.fontName);
					if ((((!(embeddedFont != null)) || (!(embeddedFont.fontType == systemFont.fontType))) || (!(embeddedFont.fontStyle == systemFont.fontStyle))))
					{
						_embeddedFonts.add(systemFont.fontName, systemFont);
					};
					index++;
				};
			}
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught); 			{
				Logger.log(["Error in FontEnum.refresh(): " + error.message + ", Stacktrace: " + error.getStackTrace()]);
			}
 }        }

	public function new() {}

	static final ___init = {

        {
            init();
        }

	null;
	};
    }

