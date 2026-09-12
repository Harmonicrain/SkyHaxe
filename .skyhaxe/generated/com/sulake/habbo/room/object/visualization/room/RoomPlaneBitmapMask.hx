package com.sulake.habbo.room.object.visualization.room
;
     class RoomPlaneBitmapMask 
    {
        var _type:String = null;
        var _leftSideLoc:Float = 0;
        var _rightSideLoc:Float = 0;

        public function new(k:String, _arg_2:Float, _arg_3:Float)
        {
            this._type = k;
            this._leftSideLoc = _arg_2;
            this._rightSideLoc = _arg_3;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var _Str_5120(get,never):Float;
public function  get__Str_5120():Float
        {
            return this._leftSideLoc;
        }

        public var _Str_4659(get,never):Float;
public function  get__Str_4659():Float
        {
            return this._rightSideLoc;
        }
    }

