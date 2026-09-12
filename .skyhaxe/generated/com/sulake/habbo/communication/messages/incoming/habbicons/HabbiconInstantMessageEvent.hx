package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconInstantMessageParser;

     class HabbiconInstantMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, HabbiconInstantMessageParser);
        }

        public function getParser():HabbiconInstantMessageParser
        {
            return Std.downcast(this._parser , HabbiconInstantMessageParser);
        }
    }

