package com.sulake.habbo.room.utils
;
     class PublicRoomWorldData
    {
        var _name:String = "";
        var _scale:Float = 1;
        var _heightScale:Float = 1;

        public function new(k:String, _arg_2:Float, _arg_3:Float)
        {
            this._name = k;
            this._scale = _arg_2;
            this._heightScale = _arg_3;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var scale(get,never):Float;
public function  get_scale():Float
        {
            return this._scale;
        }

        public var heightScale(get,never):Float;
public function  get_heightScale():Float
        {
            return this._heightScale;
        }
    }

