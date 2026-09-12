package com.sulake.habbo.window.utils
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import flash.geom.Point;

    /** July six-digit plaque number renderer used by chest inventory overlays. */
     final class ChestItemOverlayNumberBitmapGenerator
    {
        static inline final GLYPH_PREFIX=
            "unique_item_number_glyph_";

        public static function createBitmap(assets:IAssetLibrary, value:Int,
            width:Int, height:Int):BitmapData
        {
var digit = 0;            var output= new BitmapData(width, height, true, 0);
            if (value < 0 || value > 999999)
            {
                return output;
            }

            var digits:Array<ASAny> = [];
            var divisor= 100000;
            var started= false;
            var totalWidth= 0;
            var glyph:BitmapDataAsset = null;
            while (divisor >= 1)
            {
digit= Std.int(value / divisor) % 10;
                if (digit > 0 || started || divisor == 1)
                {
                    started = true;
                    glyph = cast(
                        assets.getAssetByName(GLYPH_PREFIX + Std.string(digit)), BitmapDataAsset);
                    digits.push(glyph);
                    totalWidth += Std.int(glyph.rectangle.width);
                }
                divisor = Std.int(divisor / 10);
            }

            totalWidth--;
            var point= new Point((width - totalWidth) / 2, 0);
            if (checkNullIteratee(digits)) for (_tmp_ in digits)
            {
glyph  = _tmp_;
                output.copyPixels(cast(glyph.content, BitmapData),
                    glyph.rectangle, point);
                point.x += glyph.rectangle.width;
            }
            return output;
        }

	public function new() {}
    }

