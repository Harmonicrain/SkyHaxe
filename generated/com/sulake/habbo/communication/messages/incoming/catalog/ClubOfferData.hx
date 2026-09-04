package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ClubOfferData
    {
        var _offerId:Int = 0;
        var _productCode:String;
        var _priceCredits:Int = 0;
        var _priceActivityPoints:Int = 0;
        var _Str_10007:Int = 0;
        var _vip:Bool = false;
        var _months:Int = 0;
        var _Str_10377:Int = 0;
        var _Str_9967:Int = 0;
        var _year:Int = 0;
        var _month:Int = 0;
        var _day:Int = 0;
        var _Str_4135:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._offerId = k.readInteger();
            this._productCode = k.readString();
            k.readBoolean();
            this._priceCredits = k.readInteger();
            this._priceActivityPoints = k.readInteger();
            this._Str_10007 = k.readInteger();
            this._vip = k.readBoolean();
            this._months = k.readInteger();
            this._Str_10377 = k.readInteger();
            this._Str_4135 = k.readBoolean();
            this._Str_9967 = k.readInteger();
            this._year = k.readInteger();
            this._month = k.readInteger();
            this._day = k.readInteger();
        }

        public var offerId(get,never):Int;
function  get_offerId():Int
        {
            return this._offerId;
        }

        public var productCode(get,never):String;
function  get_productCode():String
        {
            return this._productCode;
        }

        public var priceCredits(get,never):Int;
function  get_priceCredits():Int
        {
            return this._priceCredits;
        }

        public var vip(get,never):Bool;
function  get_vip():Bool
        {
            return this._vip;
        }

        public var months(get,never):Int;
function  get_months():Int
        {
            return this._months;
        }

        public var _Str_15178(get,never):Int;
function  get__Str_15178():Int
        {
            return this._Str_10377;
        }

        public var _Str_11224(get,never):Int;
function  get__Str_11224():Int
        {
            return this._Str_9967;
        }

        public var year(get,never):Int;
function  get_year():Int
        {
            return this._year;
        }

        public var month(get,never):Int;
function  get_month():Int
        {
            return this._month;
        }

        public var day(get,never):Int;
function  get_day():Int
        {
            return this._day;
        }

        public var priceActivityPoints(get,never):Int;
function  get_priceActivityPoints():Int
        {
            return this._priceActivityPoints;
        }

        public var _Str_23501(get,never):Int;
function  get__Str_23501():Int
        {
            return this._Str_10007;
        }

        public var _Str_18028(get,never):Bool;
function  get__Str_18028():Bool
        {
            return this._Str_4135;
        }
    }

