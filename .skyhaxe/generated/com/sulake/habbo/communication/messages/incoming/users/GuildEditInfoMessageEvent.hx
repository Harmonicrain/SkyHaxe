package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildEditInfoMessageParser;

     class GuildEditInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildEditInfoMessageParser);
        }

        public var data(get,never):GuildEditData;
public function  get_data():GuildEditData
        {
            return cast(_parser, GuildEditInfoMessageParser).data;
        }
    }

