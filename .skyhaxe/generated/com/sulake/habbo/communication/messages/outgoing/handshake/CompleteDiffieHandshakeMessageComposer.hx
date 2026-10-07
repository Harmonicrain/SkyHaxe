package com.sulake.habbo.communication.messages.outgoing.handshake
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IPreEncryptionMessage;

     class CompleteDiffieHandshakeMessageComposer implements IMessageComposer implements  IPreEncryptionMessage
    {
        var _publicKey:String;

        public function new(k:String)
        {
            this._publicKey = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._publicKey];
        }
    }

