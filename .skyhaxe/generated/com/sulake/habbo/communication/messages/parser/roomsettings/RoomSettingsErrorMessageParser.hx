package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomSettingsErrorMessageParser implements IMessageParser
    {
        var _roomId:Int = 0;
        var _errorCode:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            this._errorCode = k.readInteger();
            return true;
        }

        public function flush():Bool
        {
            this._roomId = 0;
            this._errorCode = 0;
            return true;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

	public function new() {}
    }

