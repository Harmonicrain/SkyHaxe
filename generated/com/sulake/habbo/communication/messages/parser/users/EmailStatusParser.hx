package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class EmailStatusParser implements IMessageParser
    {
        var _email:String;
        var _isVerified:Bool = false;
        var _allowChange:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._email = k.readString();
            this._isVerified = k.readBoolean();
            this._allowChange = k.readBoolean();
            return true;
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

	public function new() {}
    }

