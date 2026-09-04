package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserRightsMessageParser implements IMessageParser 
    {
        var _clubLevel:Int = 0;
        var _securityLevel:Int = 0;
        var _isAmbassador:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._clubLevel = k.readInteger();
            this._securityLevel = k.readInteger();
            this._isAmbassador = k.readBoolean();
            return true;
        }

        public var clubLevel(get,never):Int;
function  get_clubLevel():Int
        {
            return this._clubLevel;
        }

        public var securityLevel(get,never):Int;
function  get_securityLevel():Int
        {
            return this._securityLevel;
        }

        public var isAmbassador(get,never):Bool;
function  get_isAmbassador():Bool
        {
            return this._isAmbassador;
        }

	public function new() {}
    }

