package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BonusRareInfoMessageParser implements IMessageParser
    {
        var _productType:String;
        var _Str_4261:Int = 0;
        var _Str_5859:Int = 0;
        var _Str_7388:Int = 0;


        public function flush():Bool
        {
            this._Str_5859 = -1;
            this._Str_7388 = -1;
            this._productType = "";
            this._Str_4261 = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._productType = k.readString();
            this._Str_4261 = k.readInteger();
            this._Str_5859 = k.readInteger();
            this._Str_7388 = k.readInteger();
            return true;
        }

        public var _Str_25710(get,never):Int;
public function  get__Str_25710():Int
        {
            return this._Str_5859;
        }

        public var _Str_25484(get,never):Int;
public function  get__Str_25484():Int
        {
            return this._Str_7388;
        }

        public var productType(get,never):String;
public function  get_productType():String
        {
            return this._productType;
        }

        public var productClassId(get,never):Int;
public function  get_productClassId():Int
        {
            return this._Str_4261;
        }

	public function new() {}
    }

