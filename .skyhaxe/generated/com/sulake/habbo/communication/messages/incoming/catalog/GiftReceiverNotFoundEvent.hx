package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.GiftReceiverNotFoundParser;

     class GiftReceiverNotFoundEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GiftReceiverNotFoundParser);
        }

        public function getParser():GiftReceiverNotFoundParser
        {
            return Std.downcast(this._parser , GiftReceiverNotFoundParser);
        }
    }

