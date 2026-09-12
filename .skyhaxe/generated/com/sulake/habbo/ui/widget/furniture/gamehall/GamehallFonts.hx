package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.utils.FontEnum;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import fonts._Str_10339;
    import fonts._Str_10363;

     class GamehallFonts
    {
        static inline final VOLTER_FONT_FACE= "Volter";
        static inline final VOLTER_BOLD_FONT_FACE= "Volter Bold";
        static final VOLTER_FONT:Class<Dynamic> = _Str_10363;
        static final VOLTER_BOLD_FONT:Class<Dynamic> = _Str_10339;

        static var _registered:Bool = false;

        public static function registerVolter()
        {
            if (_registered)
            {
                return;
            }
            try
            {
                if (!FontEnum.isEmbeddedFont(VOLTER_FONT_FACE))
                {
                    FontEnum.registerFont(VOLTER_FONT);
                }
                if (!FontEnum.isEmbeddedFont(VOLTER_BOLD_FONT_FACE))
                {
                    FontEnum.registerFont(VOLTER_BOLD_FONT);
                }
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
            }
 }            _registered = true;
        }

        public static function createPanelText(caption:String, x:Int, y:Int, width:Int, height:Int, size:Int, color:UInt, align:String, underline:Bool, bold:Bool = false):TextField
        {
            registerVolter();
            var field= new TextField();
            var fontFace= bold ? VOLTER_BOLD_FONT_FACE : VOLTER_FONT_FACE;
            var format= new TextFormat(fontFace, size, ASCompat.toInt(color), false, false, underline, null, null, align);
            field.x = x;
            field.y = y;
            field.width = width;
            field.height = height;
            field.defaultTextFormat = format;
            field.setTextFormat(format);
            field.embedFonts = FontEnum.isEmbeddedFont(fontFace);
            field.antiAliasType = AntiAliasType.NORMAL;
            field.autoSize = TextFieldAutoSize.NONE;
            field.selectable = false;
            field.mouseEnabled = false;
            field.text = caption == null ? "" : caption;
            field.setTextFormat(format);
            return field;
        }

	public function new() {}
    }

