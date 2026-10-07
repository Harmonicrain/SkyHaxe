package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.InClientLinkMessageParser;

     class InClientLinkMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, InClientLinkMessageParser);
        }

        public var link(get,never):String;
public function  get_link():String
        {
            return Std.downcast(_parser , InClientLinkMessageParser).link;
        }
    }

