package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.habbo.room.IStuffData;

     class MarketPlaceOffer
    {
        var _offerId:Int = 0;
        var _furniId:Int = 0;
        var _furniType:Int = 0;
        var _extraData:String;
        var _stuffData:IStuffData;
        var _price:Int = 0;
        var _status:Int = 0;
        var _timeLeftMinutes:Int = -1;
        var _averagePrice:Int = 0;
        var _offerCount:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:IStuffData, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Int, _arg_10:Int=-1)
        {
            this._offerId = k;
            this._furniId = _arg_2;
            this._furniType = _arg_3;
            this._extraData = _arg_4;
            this._stuffData = _arg_5;
            this._price = _arg_6;
            this._status = _arg_7;
            this._timeLeftMinutes = _arg_8;
            this._averagePrice = _arg_9;
            this._offerCount = _arg_10;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var furniType(get,never):Int;
public function  get_furniType():Int
        {
            return this._furniType;
        }

        public var extraData(get,never):String;
public function  get_extraData():String
        {
            return this._extraData;
        }

        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }

        public var price(get,never):Int;
public function  get_price():Int
        {
            return this._price;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        public var timeLeftMinutes(get,never):Int;
public function  get_timeLeftMinutes():Int
        {
            return this._timeLeftMinutes;
        }

        public var averagePrice(get,never):Int;
public function  get_averagePrice():Int
        {
            return this._averagePrice;
        }

        public var offerCount(get,never):Int;
public function  get_offerCount():Int
        {
            return this._offerCount;
        }
    }

