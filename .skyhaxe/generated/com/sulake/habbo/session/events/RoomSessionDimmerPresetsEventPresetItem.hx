package com.sulake.habbo.session.events
;
     class RoomSessionDimmerPresetsEventPresetItem 
    {
        var _id:Int = 0;
        var _type:Int = 0;
        var _color:UInt = 0;
        var _light:UInt = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:UInt)
        {
            this._id = k;
            this._type = _arg_2;
            this._color = _arg_3;
            this._light = _arg_4;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var color(get,never):UInt;
public function  get_color():UInt
        {
            return this._color;
        }

        public var brightness(get,never):Int;
public function  get_brightness():Int
        {
            return ASCompat.toInt(this._light);
        }
    }

