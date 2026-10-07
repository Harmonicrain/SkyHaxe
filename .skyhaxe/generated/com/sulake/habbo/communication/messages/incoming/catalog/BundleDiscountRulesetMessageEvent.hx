package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.BundleDiscountRulesetMessageParser;

     class BundleDiscountRulesetMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BundleDiscountRulesetMessageParser);
        }

        public function getParser():BundleDiscountRulesetMessageParser
        {
            return Std.downcast(this._parser , BundleDiscountRulesetMessageParser);
        }
    }

