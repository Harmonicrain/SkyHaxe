package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomReadyMessageParser implements IMessageParser
    {
        var _roomType:String = "";
        var _roomId:Int = 0;
        var _isPublic:Bool = false;


        public var roomType(get,never):String;
public function  get_roomType():String
        {
            return this._roomType;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var isPublic(get,never):Bool;
public function  get_isPublic():Bool
        {
            return this._isPublic;
        }

        public function flush():Bool
        {
            this._roomType = "";
            this._roomId = 0;
            this._isPublic = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomType = k.readString();
            this._roomId = k.readInteger();
            this._isPublic = k.readBoolean();
            return true;
        }

	public function new() {}
    }

