package com.sulake.habbo.communication.messages.outgoing.camera.json
;
     class JsonPoint 
    {
        var _x:Int = 0;
        var _y:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._x = k;
            this._y = _arg_2;
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
    }

