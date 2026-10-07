package com.sulake.habbo.communication.messages.incoming.inventory.trading
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingItemListParser;

     class TradingItemListEvent extends MessageEvent 
    {
        public function new(k:ASFunction, _arg_2:Class<Dynamic>)
        {
            super(k, _arg_2);
        }

        public var firstUserID(get,never):Int;
public function  get_firstUserID():Int
        {
            return this.getParser().firstUserID;
        }

        public var secondUserID(get,never):Int;
public function  get_secondUserID():Int
        {
            return this.getParser().secondUserID;
        }

        public var firstUserNumItems(get,never):Int;
public function  get_firstUserNumItems():Int
        {
            return this.getParser().firstUserNumItems;
        }

        public var secondUserNumItems(get,never):Int;
public function  get_secondUserNumItems():Int
        {
            return this.getParser().secondUserNumItems;
        }

        public var firstUserNumCredits(get,never):Int;
public function  get_firstUserNumCredits():Int
        {
            return this.getParser().firstUserNumCredits;
        }

        public var secondUserNumCredits(get,never):Int;
public function  get_secondUserNumCredits():Int
        {
            return this.getParser().secondUserNumCredits;
        }

        public var firstUserItemArray(get,never):Array<ASAny>;
public function  get_firstUserItemArray():Array<ASAny>
        {
            return this.getParser().firstUserItemArray;
        }

        public var secondUserItemArray(get,never):Array<ASAny>;
public function  get_secondUserItemArray():Array<ASAny>
        {
            return this.getParser().secondUserItemArray;
        }

        public function getParser():TradingItemListParser
        {
            return Std.downcast(_parser , TradingItemListParser);
        }
    }

