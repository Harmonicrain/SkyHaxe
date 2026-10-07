package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ExtendedProfileChangedMessageParser;

     class ExtendedProfileChangedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ExtendedProfileChangedMessageParser);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return cast(_parser, ExtendedProfileChangedMessageParser).userId;
        }
    }

