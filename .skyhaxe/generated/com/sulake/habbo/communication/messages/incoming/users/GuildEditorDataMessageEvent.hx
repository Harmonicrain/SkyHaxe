package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildEditorDataMessageParser;

     class GuildEditorDataMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildEditorDataMessageParser);
        }

        public var data(get,never):GuildEditorData;
public function  get_data():GuildEditorData
        {
            return cast(_parser, GuildEditorDataMessageParser).data;
        }
    }

