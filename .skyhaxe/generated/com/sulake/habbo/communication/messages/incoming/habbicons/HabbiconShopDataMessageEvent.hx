package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconShopDataMessageParser;

     class HabbiconShopDataMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, HabbiconShopDataMessageParser);
        }

        public function getParser():HabbiconShopDataMessageParser
        {
            return Std.downcast(this._parser , HabbiconShopDataMessageParser);
        }
    }

