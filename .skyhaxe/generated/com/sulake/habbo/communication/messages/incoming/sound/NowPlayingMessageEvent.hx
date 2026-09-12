package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.NowPlayingMessageParser;

     class NowPlayingMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NowPlayingMessageParser);
        }

        public function getParser():NowPlayingMessageParser
        {
            return Std.downcast(this._parser , NowPlayingMessageParser);
        }
    }

