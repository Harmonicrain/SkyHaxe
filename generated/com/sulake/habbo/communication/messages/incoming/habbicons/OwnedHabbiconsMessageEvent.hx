package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.OwnedHabbiconsMessageParser;

     class OwnedHabbiconsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, OwnedHabbiconsMessageParser);
        }

        public function getParser():OwnedHabbiconsMessageParser
        {
            return Std.downcast(this._parser , OwnedHabbiconsMessageParser);
        }
    }

