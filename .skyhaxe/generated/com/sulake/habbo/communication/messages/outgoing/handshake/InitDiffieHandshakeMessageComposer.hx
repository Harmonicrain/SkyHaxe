package com.sulake.habbo.communication.messages.outgoing.handshake
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IPreEncryptionMessage;

     class InitDiffieHandshakeMessageComposer implements IMessageComposer implements  IPreEncryptionMessage
    {
        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [];
        }

	public function new() {}
    }

