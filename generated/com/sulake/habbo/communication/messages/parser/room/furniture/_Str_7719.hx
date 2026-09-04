package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_7719 implements IMessageParser 
    {
        var _email:String;
        var _isVerified:Bool = false;
        var _allowChange:Bool = false;
        var _furniId:Int = 0;
        var _Str_10840:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._email = k.readString();
            this._isVerified = k.readBoolean();
            this._allowChange = k.readBoolean();
            this._furniId = k.readInteger();
            this._Str_10840 = k.readBoolean();
            return true;
        }

        public var _Str_10512(get,never):Bool;
function  get__Str_10512():Bool
        {
            return this._Str_10840;
        }

        public var email(get,never):String;
function  get_email():String
        {
            return this._email;
        }

        public var isVerified(get,never):Bool;
function  get_isVerified():Bool
        {
            return this._isVerified;
        }

        public var allowChange(get,never):Bool;
function  get_allowChange():Bool
        {
            return this._allowChange;
        }

        public var furniId(get,never):Int;
function  get_furniId():Int
        {
            return this._furniId;
        }

	public function new() {}
    }

