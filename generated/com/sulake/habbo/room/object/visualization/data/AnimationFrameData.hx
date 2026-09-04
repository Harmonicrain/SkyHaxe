package com.sulake.habbo.room.object.visualization.data
;
     class AnimationFrameData 
    {
        var _id:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _randomX:Int = 0;
        var _randomY:Int = 0;
        var _repeats:Int = 1;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            this._id = k;
            this._x = _arg_2;
            this._y = _arg_3;
            this._randomX = _arg_4;
            this._randomY = _arg_5;
            this._repeats = _arg_6;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public function hasDirectionalOffsets():Bool
        {
            return false;
        }

        public function getX(k:Int):Int
        {
            return this._x;
        }

        public function getY(k:Int):Int
        {
            return this._y;
        }

        public var x(get,never):Int;
function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
function  get_y():Int
        {
            return this._x;
        }

        public var randomX(get,never):Int;
function  get_randomX():Int
        {
            return this._randomX;
        }

        public var randomY(get,never):Int;
function  get_randomY():Int
        {
            return this._randomY;
        }

        public var repeats(get,never):Int;
function  get_repeats():Int
        {
            return this._repeats;
        }
    }

