package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.TraxSongInfoMessageParser;

     class TraxSongInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, TraxSongInfoMessageParser);
        }

        public function getParser():TraxSongInfoMessageParser
        {
            return Std.downcast(this._parser , TraxSongInfoMessageParser);
        }
    }

