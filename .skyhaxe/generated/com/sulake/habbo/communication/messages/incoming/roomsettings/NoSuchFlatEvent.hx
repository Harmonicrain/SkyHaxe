package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.NoSuchFlatMessageParser;

     class NoSuchFlatEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NoSuchFlatMessageParser);
        }

        public function getParser():NoSuchFlatMessageParser
        {
            return Std.downcast(this._parser , NoSuchFlatMessageParser);
        }
    }

