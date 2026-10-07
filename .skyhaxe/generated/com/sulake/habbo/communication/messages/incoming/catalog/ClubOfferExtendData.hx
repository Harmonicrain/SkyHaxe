package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ClubOfferExtendData extends ClubOfferData
    {
        var _Str_16193:Int = 0;
        var _Str_22071:Int = 0;
        var _Str_21178:Int = 0;
        var _Str_21024:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            super(k);
            this._Str_16193 = k.readInteger();
            this._Str_22071 = k.readInteger();
            this._Str_21178 = k.readInteger();
            this._Str_21024 = k.readInteger();
        }

        public var _Str_23477(get,never):Int;
public function  get__Str_23477():Int
        {
            return this._Str_16193 * months;
        }

        public var _Str_21585(get,never):Int;
public function  get__Str_21585():Int
        {
            return this._Str_22071 * months;
        }

        public var _Str_22469(get,never):Int;
public function  get__Str_22469():Int
        {
            return this._Str_21178;
        }

        public var _Str_24050(get,never):Int;
public function  get__Str_24050():Int
        {
            return (this._Str_16193 * months) - this.priceCredits;
        }

        public var _Str_22280(get,never):Int;
public function  get__Str_22280():Int
        {
            return (this._Str_21585 * months) - this.priceActivityPoints;
        }

        public var _Str_21229(get,never):Int;
public function  get__Str_21229():Int
        {
            return this._Str_21024;
        }
    }

