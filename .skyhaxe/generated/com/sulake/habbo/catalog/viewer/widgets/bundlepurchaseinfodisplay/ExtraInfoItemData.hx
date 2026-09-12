package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay
;
     class ExtraInfoItemData 
    {
        public static inline final _Str_13400= 0;
        public static inline final _Str_14719= 1;
        public static inline final _Str_14097= 2;
        public static inline final _Str_16957= 3;
        public static inline final _Str_18371= 4;
        public static inline final _Str_17087= 5;

        var _type:Int = 0;
        var _text:String;
        var _quantity:Int = 0;
        var _activityPointType:Int = 0;
        var _discountPriceCredits:Int = 0;
        var _discountPriceActivityPoints:Int = 0;
        var _priceCredits:Int = 0;
        var _priceActivityPoints:Int = 0;
        var _badgeCode:String;
        var _achievementCode:String;

        public function new(k:Int, _arg_2:String="")
        {
            this._type = k;
            this._text = _arg_2;
        }

        
        public var text(get,set):String;
public function  set_text(k:String):String        {
            return this._text = k;
        }

        
        public var quantity(get,set):Int;
public function  set_quantity(k:Int):Int        {
            return this._quantity = k;
        }

        
        public var activityPointType(get,set):Int;
public function  set_activityPointType(k:Int):Int        {
            return this._activityPointType = k;
        }

        
        public var discountPriceCredits(get,set):Int;
public function  set_discountPriceCredits(k:Int):Int        {
            return this._discountPriceCredits = k;
        }

        
        public var discountPriceActivityPoints(get,set):Int;
public function  set_discountPriceActivityPoints(k:Int):Int        {
            return this._discountPriceActivityPoints = k;
        }

        
        public var priceCredits(get,set):Int;
public function  set_priceCredits(k:Int):Int        {
            return this._priceCredits = k;
        }

        
        public var priceActivityPoints(get,set):Int;
public function  set_priceActivityPoints(k:Int):Int        {
            return this._priceActivityPoints = k;
        }

        
        public var badgeCode(get,set):String;
public function  set_badgeCode(k:String):String        {
            return this._badgeCode = k;
        }

        
        public var _Str_23604(get,set):String;
public function  set__Str_23604(k:String):String        {
            return this._achievementCode = k;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }
public function  get_text():String
        {
            return this._text;
        }
public function  get_quantity():Int
        {
            return this._quantity;
        }
public function  get_priceCredits():Int
        {
            return this._priceCredits;
        }
public function  get_priceActivityPoints():Int
        {
            return this._priceActivityPoints;
        }
public function  get_activityPointType():Int
        {
            return this._activityPointType;
        }
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }
public function  get__Str_23604():String
        {
            return this._achievementCode;
        }
public function  get_discountPriceCredits():Int
        {
            return this._discountPriceCredits;
        }
public function  get_discountPriceActivityPoints():Int
        {
            return this._discountPriceActivityPoints;
        }
    }

