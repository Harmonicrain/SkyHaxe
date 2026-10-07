package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.OpenPetPackageResultMessageParser;

     class OpenPetPackageResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OpenPetPackageResultMessageParser);
        }

        public function getParser():OpenPetPackageResultMessageParser
        {
            return Std.downcast(_parser , OpenPetPackageResultMessageParser);
        }
    }

