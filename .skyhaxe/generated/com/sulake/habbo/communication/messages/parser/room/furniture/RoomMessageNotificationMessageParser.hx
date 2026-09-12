package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomMessageNotificationMessageParser implements IMessageParser
    {
        var _roomId:Int = 0;
        var _roomName:String;
        var _messageCount:Int = 0;


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

        public var _Str_25507(get,never):Int;
public function  get__Str_25507():Int
        {
            return this._messageCount;
        }

        public function flush():Bool
        {
            this._roomId = -1;
            this._roomName = "";
            this._messageCount = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._messageCount = k.readInteger();
            return true;
        }

	public function new() {}
    }

