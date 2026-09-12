package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconInfoMessageParser;

     class HabbiconInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, HabbiconInfoMessageParser);
        }

        public function getParser():HabbiconInfoMessageParser
        {
            return Std.downcast(this._parser , HabbiconInfoMessageParser);
        }
    }

