package com.sulake.habbo.communication.messages.incoming.mysterybox
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.mysterybox.MysteryBoxKeysMessageParser;

     class MysteryBoxKeysMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, MysteryBoxKeysMessageParser);
        }

        public function getParser():MysteryBoxKeysMessageParser
        {
            return Std.downcast(_parser , MysteryBoxKeysMessageParser);
        }
    }

