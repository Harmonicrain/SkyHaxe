package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.YoutubeDisplayVideoMessageParser;

     class YoutubeDisplayVideoMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YoutubeDisplayVideoMessageParser);
        }

        public function getParser():YoutubeDisplayVideoMessageParser
        {
            return Std.downcast(parser , YoutubeDisplayVideoMessageParser);
        }
    }

