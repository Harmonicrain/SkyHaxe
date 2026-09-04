package com.sulake.habbo.room.object
;
     class RoomPlaneMaskData 
    {
        var _leftSideLoc:Float = 0;
        var _rightSideLoc:Float = 0;
        var _leftSideLength:Float = 0;
        var _rightSideLength:Float = 0;

        public function new(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float)
        {
            this._leftSideLoc = k;
            this._rightSideLoc = _arg_2;
            this._leftSideLength = _arg_3;
            this._rightSideLength = _arg_4;
        }

        public var _Str_5120(get,never):Float;
function  get__Str_5120():Float
        {
            return this._leftSideLoc;
        }

        public var _Str_4659(get,never):Float;
function  get__Str_4659():Float
        {
            return this._rightSideLoc;
        }

        public var _Str_9124(get,never):Float;
function  get__Str_9124():Float
        {
            return this._leftSideLength;
        }

        public var _Str_12156(get,never):Float;
function  get__Str_12156():Float
        {
            return this._rightSideLength;
        }
    }

