package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.InitDiffieHandshakeParser;

     class InitDiffieHandshakeEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, InitDiffieHandshakeParser);
        }

        public var encryptedPrime(get,never):String;
function  get_encryptedPrime():String
        {
            return Std.downcast(this._parser , InitDiffieHandshakeParser).encryptedPrime;
        }

        public var encryptedGenerator(get,never):String;
function  get_encryptedGenerator():String
        {
            return Std.downcast(this._parser , InitDiffieHandshakeParser).encryptedGenerator;
        }
    }

