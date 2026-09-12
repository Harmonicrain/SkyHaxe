package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class DirectSMSClubBuyAvailableMessageParser implements IMessageParser
    {
        var _available:Bool = false;
        var _Str_16515:String;
        var _Str_22121:String;
        var _Str_21897:Int = 0;


        public function flush():Bool
        {
            this._available = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_16515 = k.readString();
            if (this._Str_16515 != "")
            {
                this._available = true;
            }
            this._Str_22121 = k.readString();
            this._Str_21897 = k.readInteger();
            return true;
        }

        public var available(get,never):Bool;
public function  get_available():Bool
        {
            return this._available;
        }

        public var _Str_26301(get,never):String;
public function  get__Str_26301():String
        {
            return this._Str_16515;
        }

        public var _Str_26118(get,never):String;
public function  get__Str_26118():String
        {
            return this._Str_22121;
        }

        public var _Str_26380(get,never):Int;
public function  get__Str_26380():Int
        {
            return this._Str_21897;
        }

	public function new() {}
    }

