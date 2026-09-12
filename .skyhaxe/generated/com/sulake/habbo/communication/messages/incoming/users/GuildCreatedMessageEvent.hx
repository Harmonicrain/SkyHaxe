package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildCreatedMessageParser;

     class GuildCreatedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildCreatedMessageParser);
        }

        public var baseRoomId(get,never):Int;
public function  get_baseRoomId():Int
        {
            return cast(_parser, GuildCreatedMessageParser).baseRoomId;
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return cast(_parser, GuildCreatedMessageParser).groupId;
        }
    }

