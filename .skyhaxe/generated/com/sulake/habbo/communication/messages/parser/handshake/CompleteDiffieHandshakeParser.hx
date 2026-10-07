package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CompleteDiffieHandshakeParser implements IMessageParser 
    {
        var _encryptedPublicKey:String;
        var _serverClientEncryption:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._encryptedPublicKey = k.readString();
            if (k.bytesAvailable != 0)
            {
                this._serverClientEncryption = k.readBoolean();
            }
            return true;
        }

        public var encryptedPublicKey(get,never):String;
public function  get_encryptedPublicKey():String
        {
            return this._encryptedPublicKey;
        }

        public var serverClientEncryption(get,never):Bool;
public function  get_serverClientEncryption():Bool
        {
            return this._serverClientEncryption;
        }

	public function new() {}
    }

