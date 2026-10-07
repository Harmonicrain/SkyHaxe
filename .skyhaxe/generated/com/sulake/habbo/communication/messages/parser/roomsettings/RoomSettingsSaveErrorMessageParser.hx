package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomSettingsSaveErrorMessageParser implements IMessageParser
    {
        public static inline final ERROR_ROOM_NOT_FOUND= 1;
        public static inline final ERROR_NOT_OWNER= 2;
        public static inline final ERROR_INVALID_DOOR_MODE= 3;
        public static inline final ERROR_INVALID_USER_LIMIT= 4;
        public static inline final ERROR_INVALID_PASSWORD= 5;
        public static inline final ERROR_INVALID_CATEGORY= 6;
        public static inline final ERROR_INVALID_NAME= 7;
        public static inline final ERROR_UNACCEPTABLE_NAME= 8;
        public static inline final ERROR_INVALID_DESCRIPTION= 9;
        public static inline final ERROR_UNACCEPTABLE_DESCRIPTION= 10;
        public static inline final ERROR_INVALID_TAG= 11;
        public static inline final ERROR_NON_USER_CHOOSABLE_TAG= 12;
        public static inline final ERROR_TOO_MANY_CHARACTERS_IN_TAG= 13;

        var _roomId:Int = 0;
        var _errorCode:Int = 0;
        var _info:String;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            this._errorCode = k.readInteger();
            this._info = k.readString();
            return true;
        }

        public function flush():Bool
        {
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

        public var info(get,never):String;
public function  get_info():String
        {
            return this._info;
        }

	public function new() {}
    }

