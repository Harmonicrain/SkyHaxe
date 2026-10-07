package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.PurchaseNotAllowedMessageParser;

     class PurchaseNotAllowedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PurchaseNotAllowedMessageParser);
        }

        public function getParser():PurchaseNotAllowedMessageParser
        {
            return Std.downcast(this._parser , PurchaseNotAllowedMessageParser);
        }
    }

