package com.sulake.habbo.catalog._enum
;
     class VideoOfferTypeEnum 
    {
        public static final CREDIT:VideoOfferTypeEnum = new VideoOfferTypeEnum(0);
        public static final _SafeStr_7697:VideoOfferTypeEnum = new VideoOfferTypeEnum(1);

        var _value:Int = 0;

        public function new(k:Int)        {
            this._value = k;
        }

        public var value(get,never):Int;
public function  get_value():Int
        {
            return this._value;
        }

        public function equals(k:VideoOfferTypeEnum):Bool
        {
            return (k != null) && (k._value == this._value);
        }
    }

