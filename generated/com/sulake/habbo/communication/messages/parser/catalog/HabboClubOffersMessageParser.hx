package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubOfferData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboClubOffersMessageParser implements IMessageParser
    {
        var _offers:Array<ASAny>;
        var _source:Int = 0;


        public function flush():Bool
        {
            this._offers = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._offers = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._offers.push(new ClubOfferData(k));
                _local_3++;
            }
            this._source = k.readInteger();
            return true;
        }

        public var offers(get,never):Array<ASAny>;
function  get_offers():Array<ASAny>
        {
            return this._offers;
        }

        public var source(get,never):Int;
function  get_source():Int
        {
            return this._source;
        }

	public function new() {}
    }

