package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionRequesterRoomMessageParser;

     class GuideSessionRequesterRoomMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideSessionRequesterRoomMessageParser);
        }

        public function getParser():GuideSessionRequesterRoomMessageParser
        {
            return Std.downcast(_parser , GuideSessionRequesterRoomMessageParser);
        }
    }

