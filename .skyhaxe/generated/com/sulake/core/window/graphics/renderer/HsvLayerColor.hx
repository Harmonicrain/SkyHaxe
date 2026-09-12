package com.sulake.core.window.graphics.renderer
;
    import flash.geom.ColorTransform;

     class HsvLayerColor
    {
        public static function configureTransform(transform:ColorTransform, color:UInt, shade:Float)
        {
            var derived= deriveColor(color, shade);
            transform.redMultiplier = (((ASCompat.toInt(derived )& 0xFF0000) >> 16) / 0xFF);
            transform.greenMultiplier = (((ASCompat.toInt(derived )& 0xFF00) >> 8) / 0xFF);
            transform.blueMultiplier = ((ASCompat.toInt(derived )& 0xFF) / 0xFF);
            transform.alphaMultiplier = 1;
            transform.redOffset = 0;
            transform.greenOffset = 0;
            transform.blueOffset = 0;
            transform.alphaOffset = 0;
        }

        public static function deriveColor(color:UInt, shade:Float):UInt
        {
            if (Math.isNaN(shade))
            {
                shade = 0;
            }
            var r= (((ASCompat.toInt(color )& 0xFF0000) >> 16) / 0xFF);
            var g= (((ASCompat.toInt(color )& 0xFF00) >> 8) / 0xFF);
            var b= ((ASCompat.toInt(color )& 0xFF) / 0xFF);
            var hsv:ASObject = rgbToHsv(r, g, b);
            if (hsv.s == 0)
            {
                hsv.s = 0;
                hsv.v = (ASCompat.toNumber(hsv.v) - shade);
            }
            else
            {
                hsv.s = clamp01(ASCompat.toNumber(hsv.s + shade));
                hsv.v = clamp01(ASCompat.toNumber(ASCompat.toNumber(hsv.v) - (shade / 2)));
            }
            return hsvToRgb(ASCompat.toNumber(hsv.h), ASCompat.toNumber(hsv.s), ASCompat.toNumber(hsv.v));
        }

        static function rgbToHsv(r:Float, g:Float, b:Float):ASObject
        {
            var max= Math.max(r, Math.max(g, b));
            var min= Math.min(r, Math.min(g, b));
            var delta= (max - min);
            var h:Float = 0;
            var s= ((max == 0) ? 0 : (delta / max));
            if (delta != 0)
            {
                if (max == r)
                {
                    h = ((g - b) / delta);
                    if (g < b)
                    {
                        h = (h + 6);
                    }
                }
                else
                {
                    if (max == g)
                    {
                        h = (((b - r) / delta) + 2);
                    }
                    else
                    {
                        h = (((r - g) / delta) + 4);
                    }
                }
                h = (h / 6);
            }
            return {
                "h": h,
                "s": s,
                "v": max
            };
        }

        static function hsvToRgb(h:Float, s:Float, v:Float):UInt
        {
            h = (h - Math.ffloor(h));
            if (s == 0)
            {
                return toColor(v, v, v);
            }
            var scaled= (h * 6);
            var sector= Std.int(Math.ffloor(scaled));
            var frac= (scaled - sector);
            var p= (v * (1 - s));
            var q= (v * (1 - (s * frac)));
            var t= (v * (1 - (s * (1 - frac))));
            switch (sector % 6)
            {
                case 0:
                    return toColor(v, t, p);
                case 1:
                    return toColor(q, v, p);
                case 2:
                    return toColor(p, v, t);
                case 3:
                    return toColor(p, q, v);
                case 4:
                    return toColor(t, p, v);
                default:
                    return toColor(v, p, q);
            }
        }

        static function toColor(r:Float, g:Float, b:Float):UInt
        {
            return (((ASCompat.toInt(toByte(r) )<< 16) | (ASCompat.toInt(toByte(g) )<< 8)) | ASCompat.toInt(toByte(b)));
        }

        static function toByte(value:Float):UInt
        {
            return ASCompat.toUInt(Math.fround(clamp01(value) * 0xFF));
        }

        static function clamp01(value:Float):Float
        {
            if ((Math.isNaN(value) || (value < 0)))
            {
                return 0;
            }
            if (value > 1)
            {
                return 1;
            }
            return value;
        }

	public function new() {}
    }

