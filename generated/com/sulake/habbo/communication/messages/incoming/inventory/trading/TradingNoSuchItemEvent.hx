package com.sulake.habbo.communication.messages.incoming.inventory.trading
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingNoSuchItemParser;

     class TradingNoSuchItemEvent extends MessageEvent 
    {
        public function new(k:ASFunction, _arg_2:Class<Dynamic>)
        {
            super(k, _arg_2);
        }

        public function getParser():TradingNoSuchItemParser
        {
            return Std.downcast(_parser , TradingNoSuchItemParser);
        }
    }

