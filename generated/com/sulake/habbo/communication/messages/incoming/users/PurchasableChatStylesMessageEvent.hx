package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ChatStyleIdsMessageParser;

     class PurchasableChatStylesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ChatStyleIdsMessageParser);
        }

        public function getParser():ChatStyleIdsMessageParser
        {
            return Std.downcast(this._parser , ChatStyleIdsMessageParser);
        }
    }

