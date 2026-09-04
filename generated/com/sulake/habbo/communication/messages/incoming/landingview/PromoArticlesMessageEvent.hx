package com.sulake.habbo.communication.messages.incoming.landingview
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.landingview.PromoArticlesMessageParser;

     class PromoArticlesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PromoArticlesMessageParser);
        }

        public function getParser():PromoArticlesMessageParser
        {
            return Std.downcast(_parser , PromoArticlesMessageParser);
        }
    }

