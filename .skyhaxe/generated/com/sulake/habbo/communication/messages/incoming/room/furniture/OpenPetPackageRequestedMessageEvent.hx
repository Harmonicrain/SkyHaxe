package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.OpenPetPackageRequestedMessageParser;

     class OpenPetPackageRequestedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OpenPetPackageRequestedMessageParser);
        }

        public function getParser():OpenPetPackageRequestedMessageParser
        {
            return Std.downcast(_parser , OpenPetPackageRequestedMessageParser);
        }
    }

