package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class PublicRoomObjectMessageData
    {
        var _hasDimensions:Bool = false;
        var _id:String;
        var _type:String;
        var _x:Int = 0;
        var _y:Int = 0;
        var _z:Int = 0;
        var _direction:Int = 0;
        var _sizeX:Int = 0;
        var _sizeY:Int = 0;

        public function new(k:Bool, _arg_2:String, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Int)
        {
            this._hasDimensions = k;
            this._id = _arg_2;
            this._type = _arg_3;
            this._x = _arg_4;
            this._y = _arg_5;
            this._z = _arg_6;
            this._direction = _arg_7;
            this._sizeX = _arg_8;
            this._sizeY = _arg_9;
        }

        public var hasDimensions(get,never):Bool;
function  get_hasDimensions():Bool
        {
            return this._hasDimensions;
        }

        public var id(get,never):String;
function  get_id():String
        {
            return this._id;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
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

        public var z(get,never):Int;
function  get_z():Int
        {
            return this._z;
        }

        public var direction(get,never):Int;
function  get_direction():Int
        {
            return this._direction;
        }

        public var sizeX(get,never):Int;
function  get_sizeX():Int
        {
            return this._sizeX;
        }

        public var sizeY(get,never):Int;
function  get_sizeY():Int
        {
            return this._sizeY;
        }
    }

