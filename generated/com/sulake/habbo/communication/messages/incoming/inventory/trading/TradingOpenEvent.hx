package com.sulake.habbo.communication.messages.incoming.inventory.trading
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingOpenParser;

     class TradingOpenEvent extends MessageEvent 
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

        public var _Str_16764(get,never):Bool;
function  get__Str_16764():Bool
        {
            return this.getParser()._Str_16764;
        }

        public var _Str_17613(get,never):Int;
function  get__Str_17613():Int
        {
            return this.getParser()._Str_17613;
        }

        public var _Str_13374(get,never):Bool;
function  get__Str_13374():Bool
        {
            return this.getParser()._Str_13374;
        }

        public function getParser():TradingOpenParser
        {
            return Std.downcast(_parser , TradingOpenParser);
        }
    }

