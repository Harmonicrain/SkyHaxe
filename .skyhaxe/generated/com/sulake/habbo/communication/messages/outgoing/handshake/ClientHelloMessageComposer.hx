package com.sulake.habbo.communication.messages.outgoing.handshake
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IPreEncryptionMessage;
    import com.sulake.habbo.communication._enum.ClientPlatform;
    import com.sulake.habbo.communication._enum.ClientDeviceCategory;

     class ClientHelloMessageComposer implements IMessageComposer implements  IPreEncryptionMessage
    {
        var _Str_24809:String = "FLASH";


        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= "PRODUCTION-201611291003-338511768";
            return [k, this._Str_24809, ClientPlatform.FLASH, ClientDeviceCategory.UNKNOWN];
        }
public function new(){}
    }

