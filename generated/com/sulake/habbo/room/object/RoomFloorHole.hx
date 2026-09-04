package com.sulake.habbo.room.object
;
     class RoomFloorHole 
    {
        var _x:Int = 0;
        var _y:Int = 0;
        var _width:Int = 0;
        var _height:Int = 0;

        public function new(x:Int, y:Int, width:Int, height:Int)
        {
            this._x = x;
            this._y = y;
            this._width = width;
            this._height = height;
        }

        public var x(get,never):Int;
function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
function  get_y():Int
        {
            return this._y;
        }

        public var width(get,never):Int;
function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
function  get_height():Int
        {
            return this._height;
        }
    }

