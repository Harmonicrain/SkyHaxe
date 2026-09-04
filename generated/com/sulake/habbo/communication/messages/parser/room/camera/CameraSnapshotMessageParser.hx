package com.sulake.habbo.communication.messages.parser.room.camera
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CameraSnapshotMessageParser implements IMessageParser
    {
        var _roomType:String = "";
        var _roomId:Int = 0;


        public var roomType(get,never):String;
function  get_roomType():String
        {
            return this._roomType;
        }

        public var roomId(get,never):Int;
function  get_roomId():Int
        {
            return this._roomId;
        }

        public function flush():Bool
        {
            this._roomType = "";
            this._roomId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomType = k.readString();
            this._roomId = k.readInteger();
            return true;
        }

	public function new() {}
    }

