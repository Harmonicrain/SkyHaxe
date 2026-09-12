package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserUnbannedFromRoomParser implements IMessageParser
    {
        var _roomId:Int = 0;
        var _userId:Int = 0;


        public function flush():Bool
        {
            this._roomId = 0;
            this._userId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            this._userId = k.readInteger();
            return true;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

	public function new() {}
    }

