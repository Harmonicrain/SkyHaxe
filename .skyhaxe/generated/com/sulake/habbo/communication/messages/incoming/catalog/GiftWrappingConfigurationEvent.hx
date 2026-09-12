package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.GiftWrappingConfigurationParser;

     class GiftWrappingConfigurationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GiftWrappingConfigurationParser);
        }

        public function getParser():GiftWrappingConfigurationParser
        {
            return Std.downcast(this._parser , GiftWrappingConfigurationParser);
        }
    }

