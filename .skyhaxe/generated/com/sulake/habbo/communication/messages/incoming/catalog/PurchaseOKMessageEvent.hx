package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.PurchaseOKMessageParser;

     class PurchaseOKMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PurchaseOKMessageParser);
        }

        public function getParser():PurchaseOKMessageParser
        {
            return Std.downcast(this._parser , PurchaseOKMessageParser);
        }
    }

