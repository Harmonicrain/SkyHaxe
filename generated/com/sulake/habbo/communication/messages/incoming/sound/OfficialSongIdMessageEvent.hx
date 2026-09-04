package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.OfficialSongIdMessageParser;

     class OfficialSongIdMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OfficialSongIdMessageParser);
        }

        public function getParser():OfficialSongIdMessageParser
        {
            return Std.downcast(this._parser , OfficialSongIdMessageParser);
        }
    }

