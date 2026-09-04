package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.YoutubeControlVideoMessageParser;

     class YoutubeControlVideoMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YoutubeControlVideoMessageParser);
        }

        public function getParser():YoutubeControlVideoMessageParser
        {
            return Std.downcast(parser , YoutubeControlVideoMessageParser);
        }
    }

