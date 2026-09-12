package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TalentTrackRewardProduct
    {
        var _productCode:String;
        var _vipDays:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._productCode = k.readString();
            this._vipDays = k.readInteger();
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var _Str_13965(get,never):Int;
public function  get__Str_13965():Int
        {
            return this._vipDays;
        }
    }

