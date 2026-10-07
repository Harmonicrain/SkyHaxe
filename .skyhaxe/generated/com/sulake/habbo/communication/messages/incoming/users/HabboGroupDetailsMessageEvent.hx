package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.HabboGroupDetailsMessageParser;

     class HabboGroupDetailsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboGroupDetailsMessageParser);
        }

        public var data(get,never):HabboGroupDetailsData;
public function  get_data():HabboGroupDetailsData
        {
            return cast(_parser, HabboGroupDetailsMessageParser).data;
        }
    }

