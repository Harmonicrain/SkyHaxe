package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class UserUpdateMessageData
    {
        var _id:Int = 0;
        var _x:Float = 0;
        var _y:Float = 0;
        var _z:Float = 0;
        var _Str_20464:Float = 0;
        var _Str_20190:Float = 0;
        var _Str_20813:Float = 0;
        var _Str_19897:Float = 0;
        var _dir:Int = 0;
        var _Str_11163:Int = 0;
        var _Str_614:Array<ASAny>;
        var _Str_19151:Bool = false;
        var _Str_11245:Bool = false;

        public function new(k:Int, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:Int, _arg_7:Int, _arg_8:Float, _arg_9:Float, _arg_10:Float, _arg_11:Bool, _arg_12:Bool, _arg_13:Array<ASAny>)
        {
            this._Str_614 = [];
            this._id = k;
            this._x = _arg_2;
            this._y = _arg_3;
            this._z = _arg_4;
            this._Str_20464 = _arg_5;
            this._dir = _arg_6;
            this._Str_11163 = _arg_7;
            this._Str_20190 = _arg_8;
            this._Str_20813 = _arg_9;
            this._Str_19897 = _arg_10;
            this._Str_19151 = _arg_11;
            this._Str_11245 = _arg_12;
            this._Str_614 = _arg_13;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var x(get,never):Float;
function  get_x():Float
        {
            return this._x;
        }

        public var y(get,never):Float;
function  get_y():Float
        {
            return this._y;
        }

        public var z(get,never):Float;
function  get_z():Float
        {
            return this._z;
        }

        public var _Str_23720(get,never):Float;
function  get__Str_23720():Float
        {
            return this._Str_20464;
        }

        public var _Str_24054(get,never):Float;
function  get__Str_24054():Float
        {
            return this._Str_20190;
        }

        public var _Str_24331(get,never):Float;
function  get__Str_24331():Float
        {
            return this._Str_20813;
        }

        public var _Str_25822(get,never):Float;
function  get__Str_25822():Float
        {
            return this._Str_19897;
        }

        public var dir(get,never):Int;
function  get_dir():Int
        {
            return this._dir;
        }

        public var dirHead(get,never):Int;
function  get_dirHead():Int
        {
            return this._Str_11163;
        }

        public var isMoving(get,never):Bool;
function  get_isMoving():Bool
        {
            return this._Str_19151;
        }

        public var canStandUp(get,never):Bool;
function  get_canStandUp():Bool
        {
            return this._Str_11245;
        }

        public var actions(get,never):Array<ASAny>;
function  get_actions():Array<ASAny>
        {
            return this._Str_614.slice(0);
        }
    }

