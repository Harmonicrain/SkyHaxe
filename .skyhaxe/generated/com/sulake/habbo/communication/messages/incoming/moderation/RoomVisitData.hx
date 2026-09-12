package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomVisitData
    {
        var _roomId:Int = 0;
        var _roomName:String;
        var _enterHour:Int = 0;
        var _enterMinute:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._enterHour = k.readInteger();
            this._enterMinute = k.readInteger();
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var roomName(get,never):String;
public function  get_roomName():String
        {
            return this._roomName;
        }

        public var enterHour(get,never):Int;
public function  get_enterHour():Int
        {
            return this._enterHour;
        }

        public var enterMinute(get,never):Int;
public function  get_enterMinute():Int
        {
            return this._enterMinute;
        }
    }

