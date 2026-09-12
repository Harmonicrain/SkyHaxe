package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.CustomStackingHeightUpdateMessageParser;

     class CustomStackingHeightUpdateMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CustomStackingHeightUpdateMessageParser);
        }

        public function getParser():CustomStackingHeightUpdateMessageParser
        {
            return Std.downcast(_parser , CustomStackingHeightUpdateMessageParser);
        }
    }

