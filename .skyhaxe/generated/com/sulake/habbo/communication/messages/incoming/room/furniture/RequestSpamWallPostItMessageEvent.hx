package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RequestSpamWallPostItMessageParser;

     class RequestSpamWallPostItMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RequestSpamWallPostItMessageParser);
        }

        public function getParser():RequestSpamWallPostItMessageParser
        {
            return Std.downcast(_parser , RequestSpamWallPostItMessageParser);
        }
    }

