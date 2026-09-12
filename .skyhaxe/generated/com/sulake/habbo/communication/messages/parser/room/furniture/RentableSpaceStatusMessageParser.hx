package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RentableSpaceStatusMessageParser implements IMessageParser
    {
        var _Str_16670:Bool = false;
        var _renterId:Int = 0;
        var _Str_18360:String;
        var _Str_20575:Bool = false;
        var _Str_16491:Int = 0;
        var _Str_22009:Int = 0;
        var _price:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_16670 = k.readBoolean();
            this._Str_16491 = k.readInteger();
            this._Str_20575 = (this._Str_16491 == 0);
            this._renterId = k.readInteger();
            this._Str_18360 = k.readString();
            this._Str_22009 = k.readInteger();
            this._price = k.readInteger();
            if (!this._Str_16670)
            {
                this._renterId = -1;
                this._Str_18360 = "";
            }
            return true;
        }

        public var _Str_22736(get,never):Bool;
public function  get__Str_22736():Bool
        {
            return this._Str_16670;
        }

        public var renterId(get,never):Int;
public function  get_renterId():Int
        {
            return this._renterId;
        }

        public var _Str_23275(get,never):String;
public function  get__Str_23275():String
        {
            return this._Str_18360;
        }

        public var _Str_23603(get,never):Bool;
public function  get__Str_23603():Bool
        {
            return this._Str_20575;
        }

        public var price(get,never):Int;
public function  get_price():Int
        {
            return this._price;
        }

        public var _Str_24083(get,never):Int;
public function  get__Str_24083():Int
        {
            return this._Str_22009;
        }

        public var _Str_25070(get,never):Int;
public function  get__Str_25070():Int
        {
            return this._Str_16491;
        }

	public function new() {}
    }

