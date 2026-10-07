package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.CompleteDiffieHandshakeParser;

     class CompleteDiffieHandshakeEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CompleteDiffieHandshakeParser);
        }

        public var encryptedPublicKey(get,never):String;
public function  get_encryptedPublicKey():String
        {
            return Std.downcast(this._parser , CompleteDiffieHandshakeParser).encryptedPublicKey;
        }

        public var serverClientEncryption(get,never):Bool;
public function  get_serverClientEncryption():Bool
        {
            return Std.downcast(this._parser , CompleteDiffieHandshakeParser).serverClientEncryption;
        }
    }

