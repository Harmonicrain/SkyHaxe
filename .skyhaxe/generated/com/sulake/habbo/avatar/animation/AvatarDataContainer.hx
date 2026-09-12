package com.sulake.habbo.avatar.animation
;
    import flash.geom.ColorTransform;
    import com.sulake.core.utils.Map;

     class AvatarDataContainer implements IAvatarDataContainer 
    {
        var _ink:Int = 0;
        var _foreGround:UInt = 0;
        var _backGround:UInt = 0;
        var _colorTransform:ColorTransform;
        var _rgb:UInt = 0;
        var _r:UInt = 0;
        var _g:UInt = 0;
        var _b:UInt = 0;
        var _redMultiplier:Float = 1;
        var _greenMultiplier:Float = 1;
        var _blueMultiplier:Float = 1;
        var _alphaMultiplier:Float = 1;
        var _colorMap:Map;
        var _paletteIsGrayscale:Bool = true;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._ink = ASCompat.parseInt(k.attribute("ink").toString());
            var _local_2= k.attribute("foreground").toString();
            _local_2 = ASCompat.stringReplace(_local_2, "#", "");
            var _local_3= k.attribute("background").toString();
            _local_3 = ASCompat.stringReplace(_local_3, "#", "");
            this._foreGround = ASCompat.parseInt(_local_2, 16);
            this._backGround = ASCompat.parseInt(_local_3, 16);
            this._rgb = ASCompat.parseInt(_local_2, 16);
            this._r = ((ASCompat.toInt(this._rgb )>> 16) & 0xFF);
            this._g = ((ASCompat.toInt(this._rgb )>> 8) & 0xFF);
            this._b = ((ASCompat.toInt(this._rgb )>> 0) & 0xFF);
            this._redMultiplier = ((this._r / 0xFF) * 1);
            this._greenMultiplier = ((this._g / 0xFF) * 1);
            this._blueMultiplier = ((this._b / 0xFF) * 1);
            if (this._ink == 37)
            {
                this._alphaMultiplier = 0.5;
                this._paletteIsGrayscale = false;
            }
            this._colorTransform = new ColorTransform(this._redMultiplier, this._greenMultiplier, this._blueMultiplier, this._alphaMultiplier);
            this._colorMap = this.generatePaletteMapForGrayscale(this._backGround, this._foreGround);
        }

        public var ink(get,never):Int;
public function  get_ink():Int
        {
            return this._ink;
        }

        public var colorTransform(get,never):ColorTransform;
public function  get_colorTransform():ColorTransform
        {
            return this._colorTransform;
        }

        public var reds(get,never):Array<ASAny>;
public function  get_reds():Array<ASAny>
        {
            return ASCompat.dynamicAs(this._colorMap.getValue("reds") , Array);
        }

        public var greens(get,never):Array<ASAny>;
public function  get_greens():Array<ASAny>
        {
            return ASCompat.dynamicAs(this._colorMap.getValue("greens") , Array);
        }

        public var blues(get,never):Array<ASAny>;
public function  get_blues():Array<ASAny>
        {
            return ASCompat.dynamicAs(this._colorMap.getValue("blues") , Array);
        }

        public var alphas(get,never):Array<ASAny>;
public function  get_alphas():Array<ASAny>
        {
            return ASCompat.dynamicAs(this._colorMap.getValue("alphas") , Array);
        }

        public var paletteIsGrayscale(get,never):Bool;
public function  get_paletteIsGrayscale():Bool
        {
            return this._paletteIsGrayscale;
        }

        function generatePaletteMapForGrayscale(k:UInt, _arg_2:UInt):Map
        {
            var _local_3:ASAny = ((ASCompat.toInt(k )>> 24) & 0xFF);
            var _local_4:ASAny = ((ASCompat.toInt(k )>> 16) & 0xFF);
            var _local_5:ASAny = ((ASCompat.toInt(k )>> 8) & 0xFF);
            var _local_6:ASAny = ((ASCompat.toInt(k )>> 0) & 0xFF);
            var _local_7:ASAny = ((ASCompat.toInt(_arg_2 )>> 24) & 0xFF);
            var _local_8:ASAny = ((ASCompat.toInt(_arg_2 )>> 16) & 0xFF);
            var _local_9:ASAny = ((ASCompat.toInt(_arg_2 )>> 8) & 0xFF);
            var _local_10:ASAny = ((ASCompat.toInt(_arg_2 )>> 0) & 0xFF);
            var _local_11= (ASCompat.toNumber(ASCompat.toNumber(_local_7) - ASCompat.toNumber(_local_3)) / 0xFF);
            var _local_12= (ASCompat.toNumber(ASCompat.toNumber(_local_8) - ASCompat.toNumber(_local_4)) / 0xFF);
            var _local_13= (ASCompat.toNumber(ASCompat.toNumber(_local_9) - ASCompat.toNumber(_local_5)) / 0xFF);
            var _local_14= (ASCompat.toNumber(ASCompat.toNumber(_local_10) - ASCompat.toNumber(_local_6)) / 0xFF);
            var _local_15= new Map();
            var _local_16:Array<ASAny> = [];
            var _local_17:Array<ASAny> = [];
            var _local_18:Array<ASAny> = [];
            var _local_19:Array<ASAny> = [];
            var _local_20= ASCompat.toNumber(_local_3);
            var _local_21= ASCompat.toNumber(_local_4);
            var _local_22= ASCompat.toNumber(_local_5);
            var _local_23= ASCompat.toNumber(_local_6);
            var _local_24 = 0;
            while (_local_24 < 0x0100)
            {
                if ((((_local_21 == _local_4) && (_local_22 == _local_5)) && (_local_23 == _local_6)))
                {
                    _local_20 = 0;
                }
                _local_20 = (_local_20 + _local_11);
                _local_21 = (_local_21 + _local_12);
                _local_22 = (_local_22 + _local_13);
                _local_23 = (_local_23 + _local_14);
                _local_19.push((Std.int(_local_20 )<< 24));
                _local_16.push(((((Std.int(_local_20 )<< 24) | (Std.int(_local_21 )<< 16)) | (Std.int(_local_22 )<< 8)) | Std.int(_local_23)));
                _local_17.push(((((Std.int(_local_20 )<< 24) | (Std.int(_local_21 )<< 16)) | (Std.int(_local_22 )<< 8)) | Std.int(_local_23)));
                _local_18.push(((((Std.int(_local_20 )<< 24) | (Std.int(_local_21 )<< 16)) | (Std.int(_local_22 )<< 8)) | Std.int(_local_23)));
                _local_24++;
            }
            _local_15.add("alphas", _local_16);
            _local_15.add("reds", _local_16);
            _local_15.add("greens", _local_17);
            _local_15.add("blues", _local_18);
            return _local_15;
        }
    }

