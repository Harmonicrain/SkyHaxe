package com.sulake.habbo.communication.messages.incoming.users
;
     class RoomEntryData
    {
        var _roomId:Int = 0;
        var _roomName:String;
        var _hasControllers:Bool = false;

        public function new(k:Int, _arg_2:String, _arg_3:Bool)
        {
            this._roomId = k;
            this._roomName = _arg_2;
            this._hasControllers = _arg_3;
        }

        public var roomId(get,never):Int;
function  get_roomId():Int
        {
            return this._roomId;
        }

        public var roomName(get,never):String;
function  get_roomName():String
        {
            return this._roomName;
        }

        public var _Str_22776(get,never):Bool;
function  get__Str_22776():Bool
        {
            return this._hasControllers;
        }
    }

