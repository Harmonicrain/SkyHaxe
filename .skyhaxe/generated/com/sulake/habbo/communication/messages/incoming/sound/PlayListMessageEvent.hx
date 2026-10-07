package com.sulake.habbo.communication.messages.incoming.sound
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.sound.PlayListMessageParser;

     class PlayListMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PlayListMessageParser);
        }

        public function getParser():PlayListMessageParser
        {
            return Std.downcast(this._parser , PlayListMessageParser);
        }
    }

