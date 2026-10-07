package com.sulake.habbo.communication.messages.incoming.gifts
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.gifts.PhoneCollectionStateParser;

     class PhoneCollectionStateMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PhoneCollectionStateParser);
        }

        public function getParser():PhoneCollectionStateParser
        {
            return Std.downcast(_parser , PhoneCollectionStateParser);
        }
    }

