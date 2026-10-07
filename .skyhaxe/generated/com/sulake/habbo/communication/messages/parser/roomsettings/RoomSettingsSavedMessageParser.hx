package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomSettingsSavedMessageParser implements IMessageParser
    {
        var _roomId:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            return true;
        }

        public function flush():Bool
        {
            this._roomId = 0;
            return true;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

	public function new() {}
    }

