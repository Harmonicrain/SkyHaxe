package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketplaceItemStatsParser implements IMessageParser
    {
        var _averagePrice:Int = 0;
        var _currentOfferCount:Int = 0;
        var _historyLength:Int = 0;
        var _dayOffsets:Array<ASAny>;
        var _averagePrices:Array<ASAny>;
        var _soldAmounts:Array<ASAny>;
        var _furniTypeId:Int = 0;
        var _furniCategoryId:Int = 0;


        public var averagePrice(get,never):Int;
function  get_averagePrice():Int
        {
            return this._averagePrice;
        }

        public var offerCount(get,never):Int;
function  get_offerCount():Int
        {
            return this._currentOfferCount;
        }

        public var historyLength(get,never):Int;
function  get_historyLength():Int
        {
            return this._historyLength;
        }

        public var dayOffsets(get,never):Array<ASAny>;
function  get_dayOffsets():Array<ASAny>
        {
            return this._dayOffsets;
        }

        public var averagePrices(get,never):Array<ASAny>;
function  get_averagePrices():Array<ASAny>
        {
            return this._averagePrices;
        }

        public var soldAmounts(get,never):Array<ASAny>;
function  get_soldAmounts():Array<ASAny>
        {
            return this._soldAmounts;
        }

        public var furniTypeId(get,never):Int;
function  get_furniTypeId():Int
        {
            return this._furniTypeId;
        }

        public var furniCategoryId(get,never):Int;
function  get_furniCategoryId():Int
        {
            return this._furniCategoryId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._averagePrice = k.readInteger();
            this._currentOfferCount = k.readInteger();
            this._historyLength = k.readInteger();
            var _local_2= k.readInteger();
            this._dayOffsets = [];
            this._averagePrices = [];
            this._soldAmounts = [];
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._dayOffsets.push(k.readInteger());
                this._averagePrices.push(k.readInteger());
                this._soldAmounts.push(k.readInteger());
                _local_3++;
            }
            this._furniCategoryId = k.readInteger();
            this._furniTypeId = k.readInteger();
            return true;
        }

	public function new() {}
    }

