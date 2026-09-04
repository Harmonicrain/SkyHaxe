package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.PurchasableChatStyleChangedMessageParser;

     class PurchasableChatStyleChangedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PurchasableChatStyleChangedMessageParser);
        }

        public function getParser():PurchasableChatStyleChangedMessageParser
        {
            return Std.downcast(this._parser , PurchasableChatStyleChangedMessageParser);
        }
    }

