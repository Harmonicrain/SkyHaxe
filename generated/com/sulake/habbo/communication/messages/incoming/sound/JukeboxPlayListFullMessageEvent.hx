package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.JukeboxPlayListFullMessageParser;

     class JukeboxPlayListFullMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, JukeboxPlayListFullMessageParser);
        }

        public function getParser():JukeboxPlayListFullMessageParser
        {
            return Std.downcast(this._parser , JukeboxPlayListFullMessageParser);
        }
    }

