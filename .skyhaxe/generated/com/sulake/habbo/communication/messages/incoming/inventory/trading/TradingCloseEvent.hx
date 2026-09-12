package com.sulake.habbo.communication.messages.incoming.inventory.trading
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingCloseParser;

     class TradingCloseEvent extends MessageEvent 
    {
        public function new(k:ASFunction, _arg_2:Class<Dynamic>)
        {
            super(k, _arg_2);
        }

        public var userID(get,never):Int;
public function  get_userID():Int
        {
            return this.getParser().userID;
        }

        public function getParser():TradingCloseParser
        {
            return Std.downcast(_parser , TradingCloseParser);
        }
    }

