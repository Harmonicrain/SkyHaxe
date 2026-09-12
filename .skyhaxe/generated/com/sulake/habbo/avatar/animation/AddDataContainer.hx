package com.sulake.habbo.avatar.animation
;
     class AddDataContainer 
    {
        var _id:String;
        var _align:String;
        var _base:String;
        var _ink:String;
        var _blend:Float = 1;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._id = k.attribute("id").toString();
            this._align = k.attribute("align").toString();
            this._base = k.attribute("base").toString();
            this._ink = k.attribute("ink").toString();
            var _local_2= k.attribute("blend").toString();
            if (_local_2.length > 0)
            {
                this._blend = ASCompat.toNumber(_local_2);
                if (this._blend > 1)
                {
                    this._blend = (this._blend / 100);
                }
            }
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var align(get,never):String;
public function  get_align():String
        {
            return this._align;
        }

        public var base(get,never):String;
public function  get_base():String
        {
            return this._base;
        }

        public var ink(get,never):String;
public function  get_ink():String
        {
            return this._ink;
        }

        public var blend(get,never):Float;
public function  get_blend():Float
        {
            return this._blend;
        }

        public var isBlended(get,never):Bool;
public function  get_isBlended():Bool
        {
            return !(this._blend == 1);
        }
    }

