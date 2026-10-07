package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomForwardMessageParser implements IMessageParser
    {
        var _roomId:Int = 0;


        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            return true;
        }

	public function new() {}
    }

