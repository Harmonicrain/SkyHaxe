package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.YoutubeDisplayPlaylistsMessageParser;

     class YoutubeDisplayPlaylistsEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, YoutubeDisplayPlaylistsMessageParser);
        }

        public function getParser():YoutubeDisplayPlaylistsMessageParser
        {
            return Std.downcast(parser , YoutubeDisplayPlaylistsMessageParser);
        }
    }

