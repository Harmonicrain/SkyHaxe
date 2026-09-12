package com.sulake.habbo.battleball
;
    import com.sulake.core.utils.FontEnum;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /** Flash-only drawing helpers retained for the live RoomEngine arena surface and its overlays. */
     class BattleBallChrome
    {
        public static final ROW_ICONS:ASObject = {
            "created": "bb_ico_thumb", "started": "bb_ico_bounce", "finished": "bb_ico_flag"
        };
        public static final ROW_ICON_X:ASObject = { "bb_ico_thumb": 8, "bb_ico_bounce": 3, "bb_ico_flag": 4 };
        public static final ROW_ICON_Y:ASObject = { "bb_ico_thumb": 6, "bb_ico_bounce": 4, "bb_ico_flag": 4 };
        public static final ROW_ICON_W:ASObject = { "bb_ico_thumb": 17, "bb_ico_bounce": 24, "bb_ico_flag": 24 };
        public static final ROW_ICON_H:ASObject = { "bb_ico_thumb": 19, "bb_ico_bounce": 24, "bb_ico_flag": 24 };

        var _assets:BattleBallAssets;

        public function new(assets:BattleBallAssets) { this._assets = assets; }
        public function dispose() { this._assets = null; }

        public function pieceInto(target:Sprite, member:String, x:Int, y:Int, width:Int, height:Int,
                                  flipH:Bool=false):DisplayObject
        {
            if (target == null || width <= 0 || height <= 0 || this._assets == null) return null;
            if (flipH) x -= width;
            var display= this._assets.display("hh_game_bb_ui_" + member);
            if (display == null || display.width <= 0 || display.height <= 0) return null;
            var bitmap= Std.downcast(display , Bitmap);
            if (bitmap != null) bitmap.smoothing = false;
            display.scaleX = width / display.width;
            display.scaleY = height / display.height;
            display.y = y;
            if (flipH) { display.scaleX = -display.scaleX; display.x = x + width; }
            else display.x = x;
            target.addChild(display);
            return display;
        }

        public function textField(value:String, x:Int, y:Int, width:Int, height:Int, size:Int,
                                  colour:UInt, bold:Bool):TextField
        {
            var face= bold && FontEnum.isEmbeddedFont("Volter Bold")
                ? "Volter Bold" : "Volter";
            var field= new TextField();
            field.embedFonts = FontEnum.isEmbeddedFont(face);
            field.defaultTextFormat = new TextFormat(face, size, ASCompat.toInt(colour), bold,
                null, null, null, null, "center");
            field.text = value;
            field.x = x; field.y = y; field.width = width; field.height = height;
            field.selectable = false; field.mouseEnabled = false;
            return field;
        }
    }

