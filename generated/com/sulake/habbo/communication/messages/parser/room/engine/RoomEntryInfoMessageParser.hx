package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomEntryInfoMessageParser implements IMessageParser
    {
        var _guestRoomId:Int = 0;
        var _owner:Bool = false;


        public var guestRoomId(get,never):Int;
function  get_guestRoomId():Int
        {
            return this._guestRoomId;
        }

        public var owner(get,never):Bool;
function  get_owner():Bool
        {
            return this._owner;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._guestRoomId = k.readInteger();
            this._owner = k.readBoolean();
            return true;
        }

	public function new() {}
    }

