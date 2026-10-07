package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.PurchaseErrorMessageParser;

     class PurchaseErrorMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PurchaseErrorMessageParser);
        }

        public function getParser():PurchaseErrorMessageParser
        {
            return Std.downcast(this._parser , PurchaseErrorMessageParser);
        }
    }

