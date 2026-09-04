package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconStatusChangedMessageParser;

     class HabbiconStatusChangedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, HabbiconStatusChangedMessageParser);
        }

        public function getParser():HabbiconStatusChangedMessageParser
        {
            return Std.downcast(this._parser , HabbiconStatusChangedMessageParser);
        }
    }

