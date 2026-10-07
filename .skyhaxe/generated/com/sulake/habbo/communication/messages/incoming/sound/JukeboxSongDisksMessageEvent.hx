package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.JukeboxSongDisksMessageParser;

     class JukeboxSongDisksMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, JukeboxSongDisksMessageParser);
        }

        public function getParser():JukeboxSongDisksMessageParser
        {
            return Std.downcast(this._parser , JukeboxSongDisksMessageParser);
        }
    }

