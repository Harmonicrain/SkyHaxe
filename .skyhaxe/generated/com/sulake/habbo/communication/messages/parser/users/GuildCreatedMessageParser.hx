package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildCreatedMessageParser implements IMessageParser
    {
        var _baseRoomId:Int = 0;
        var _groupId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._baseRoomId = k.readInteger();
            this._groupId = k.readInteger();
            return true;
        }

        public var baseRoomId(get,never):Int;
public function  get_baseRoomId():Int
        {
            return this._baseRoomId;
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

	public function new() {}
    }

