package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class InitDiffieHandshakeParser implements IMessageParser 
    {
        var _encryptedPrime:String;
        var _encryptedGenerator:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._encryptedPrime = k.readString();
            this._encryptedGenerator = k.readString();
            return true;
        }

        public var encryptedPrime(get,never):String;
public function  get_encryptedPrime():String
        {
            return this._encryptedPrime;
        }

        public var encryptedGenerator(get,never):String;
public function  get_encryptedGenerator():String
        {
            return this._encryptedGenerator;
        }

	public function new() {}
    }

