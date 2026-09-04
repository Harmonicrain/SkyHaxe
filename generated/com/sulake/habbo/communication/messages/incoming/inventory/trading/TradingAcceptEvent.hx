package com.sulake.habbo.communication.messages.incoming.inventory.trading
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingAcceptParser;

     class TradingAcceptEvent extends MessageEvent 
    {
        public function new(k:ASFunction, _arg_2:Class<Dynamic>)
        {
            super(k, _arg_2);
        }

        public var userID(get,never):Int;
function  get_userID():Int
        {
            return this.getParser().userID;
        }

        public var _Str_15794(get,never):Bool;
function  get__Str_15794():Bool
        {
            return this.getParser()._Str_15794;
        }

        public function getParser():TradingAcceptParser
        {
            return Std.downcast(_parser , TradingAcceptParser);
        }
    }

