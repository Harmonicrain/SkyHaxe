package com.sulake.habbo.catalog.marketplace
;
     class MarketplaceItemStats 
    {
        var _averagePrice:Int = 0;
        var _currentOfferCount:Int = 0;
        var _historyLength:Int = 0;
        var _dayOffsets:Array<ASAny>;
        var _averagePrices:Array<ASAny>;
        var _soldAmounts:Array<ASAny>;
        var _furniTypeId:Int = 0;
        var _furniCategoryId:Int = 0;


        
        public var averagePrice(get,set):Int;
public function  get_averagePrice():Int
        {
            return this._averagePrice;
        }

        
        public var offerCount(get,set):Int;
public function  get_offerCount():Int
        {
            return this._currentOfferCount;
        }

        
        public var historyLength(get,set):Int;
public function  get_historyLength():Int
        {
            return this._historyLength;
        }

        
        public var dayOffsets(get,set):Array<ASAny>;
public function  get_dayOffsets():Array<ASAny>
        {
            return this._dayOffsets;
        }

        
        public var averagePrices(get,set):Array<ASAny>;
public function  get_averagePrices():Array<ASAny>
        {
            return this._averagePrices;
        }

        
        public var soldAmounts(get,set):Array<ASAny>;
public function  get_soldAmounts():Array<ASAny>
        {
            return this._soldAmounts;
        }

        
        public var furniTypeId(get,set):Int;
public function  get_furniTypeId():Int
        {
            return this._furniTypeId;
        }

        
        public var furniCategoryId(get,set):Int;
public function  get_furniCategoryId():Int
        {
            return this._furniCategoryId;
        }
public function  set_averagePrice(k:Int):Int        {
            return this._averagePrice = k;
        }
public function  set_offerCount(k:Int):Int        {
            return this._currentOfferCount = k;
        }
public function  set_historyLength(k:Int):Int        {
            return this._historyLength = k;
        }
public function  set_dayOffsets(k:Array<ASAny>):Array<ASAny>        {
            this._dayOffsets = k.slice(0);
return k;
        }
public function  set_averagePrices(k:Array<ASAny>):Array<ASAny>        {
            this._averagePrices = k.slice(0);
return k;
        }
public function  set_soldAmounts(k:Array<ASAny>):Array<ASAny>        {
            this._soldAmounts = k.slice(0);
return k;
        }
public function  set_furniTypeId(k:Int):Int        {
            return this._furniTypeId = k;
        }
public function  set_furniCategoryId(k:Int):Int        {
            return this._furniCategoryId = k;
        }
public function new(){}
    }

