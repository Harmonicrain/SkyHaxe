package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.HandItemReceivedMessageParser;

     class HandItemReceivedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HandItemReceivedMessageParser);
        }

        public var giverUserId(get,never):Int;
public function  get_giverUserId():Int
        {
            return cast(_parser, HandItemReceivedMessageParser).giverUserId;
        }

        public var handItemType(get,never):Int;
public function  get_handItemType():Int
        {
            return cast(_parser, HandItemReceivedMessageParser).handItemType;
        }
    }

