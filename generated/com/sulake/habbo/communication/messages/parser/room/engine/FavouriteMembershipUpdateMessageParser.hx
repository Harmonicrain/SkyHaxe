package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FavouriteMembershipUpdateMessageParser implements IMessageParser
    {
        var _roomIndex:Int = 0;
        var _habboGroupId:Int = 0;
        var _status:Int = 0;
        var _habboGroupName:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomIndex = k.readInteger();
            this._habboGroupId = k.readInteger();
            this._status = k.readInteger();
            this._habboGroupName = k.readString();
            return true;
        }

        public var roomIndex(get,never):Int;
function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var habboGroupId(get,never):Int;
function  get_habboGroupId():Int
        {
            return this._habboGroupId;
        }

        public var status(get,never):Int;
function  get_status():Int
        {
            return this._status;
        }

        public var habboGroupName(get,never):String;
function  get_habboGroupName():String
        {
            return this._habboGroupName;
        }

	public function new() {}
    }

