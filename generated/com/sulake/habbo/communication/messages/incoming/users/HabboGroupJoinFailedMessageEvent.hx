package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.HabboGroupJoinFailedMessageParser;

     class HabboGroupJoinFailedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboGroupJoinFailedMessageParser);
        }

        public var reason(get,never):Int;
function  get_reason():Int
        {
            return cast(_parser, HabboGroupJoinFailedMessageParser).reason;
        }
    }

