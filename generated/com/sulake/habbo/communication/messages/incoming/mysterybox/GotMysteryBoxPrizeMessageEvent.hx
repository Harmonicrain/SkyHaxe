package com.sulake.habbo.communication.messages.incoming.mysterybox
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.mysterybox.GotMysteryBoxPrizeMessageParser;

     class GotMysteryBoxPrizeMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GotMysteryBoxPrizeMessageParser);
        }

        public function getParser():GotMysteryBoxPrizeMessageParser
        {
            return Std.downcast(_parser , GotMysteryBoxPrizeMessageParser);
        }
    }

