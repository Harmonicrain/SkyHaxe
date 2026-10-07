package com.sulake.habbo.avatar.structure.figure
;
    import flash.geom.ColorTransform;

     class PartColor implements IPartColor 
    {
        var _id:Int = 0;
        var _index:Int = 0;
        var _clubLevel:Int = 0;
        var _isSelectable:Bool = false;
        var _rgb:UInt = 0;
        var _r:UInt = 0;
        var _g:UInt = 0;
        var _b:UInt = 0;
        var _redMultiplier:Float = Math.NaN;
        var _greenMultiplier:Float = Math.NaN;
        var _blueMultiplier:Float = Math.NaN;
        var _colorTransform:ColorTransform;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._id = ASCompat.parseInt(k.attribute("id").toString());
            this._index = ASCompat.parseInt(k.attribute("index").toString());
            this._clubLevel = ASCompat.parseInt(k.attribute("club").toString());
            this._isSelectable = ASCompat.toBool(ASCompat.parseInt(k.attribute("selectable").toString()));
            var _local_2= ASCompat.xmlListToString(k.text());
            this._rgb = ASCompat.parseInt(_local_2, 16);
            this._r = ((ASCompat.toInt(this._rgb )>> 16) & 0xFF);
            this._g = ((ASCompat.toInt(this._rgb )>> 8) & 0xFF);
            this._b = ((ASCompat.toInt(this._rgb )>> 0) & 0xFF);
            this._redMultiplier = ((this._r / 0xFF) * 1);
            this._greenMultiplier = ((this._g / 0xFF) * 1);
            this._blueMultiplier = ((this._b / 0xFF) * 1);
            this._colorTransform = new ColorTransform(this._redMultiplier, this._greenMultiplier, this._blueMultiplier);
        }

        public var colorTransform(get,never):ColorTransform;
public function  get_colorTransform():ColorTransform
        {
            return this._colorTransform;
        }

        public var redMultiplier(get,never):Float;
public function  get_redMultiplier():Float
        {
            return this._redMultiplier;
        }

        public var greenMultiplier(get,never):Float;
public function  get_greenMultiplier():Float
        {
            return this._greenMultiplier;
        }

        public var blueMultiplier(get,never):Float;
public function  get_blueMultiplier():Float
        {
            return this._blueMultiplier;
        }

        public var _Str_915(get,never):UInt;
public function  get__Str_915():UInt
        {
            return this._rgb;
        }

        public var r(get,never):UInt;
public function  get_r():UInt
        {
            return this._r;
        }

        public var g(get,never):UInt;
public function  get_g():UInt
        {
            return this._g;
        }

        public var b(get,never):UInt;
public function  get_b():UInt
        {
            return this._b;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return this._clubLevel;
        }

        public var isSelectable(get,never):Bool;
public function  get_isSelectable():Bool
        {
            return this._isSelectable;
        }
    }

