package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.PlayListSongAddedMessageParser;

     class PlayListSongAddedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PlayListSongAddedMessageParser);
        }

        public function getParser():PlayListSongAddedMessageParser
        {
            return Std.downcast(this._parser , PlayListSongAddedMessageParser);
        }
    }

