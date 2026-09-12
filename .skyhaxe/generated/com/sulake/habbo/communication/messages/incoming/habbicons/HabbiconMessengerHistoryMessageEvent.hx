package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconMessengerHistoryMessageParser;

     class HabbiconMessengerHistoryMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, HabbiconMessengerHistoryMessageParser);
        }

        public function getParser():HabbiconMessengerHistoryMessageParser
        {
            return Std.downcast(this._parser , HabbiconMessengerHistoryMessageParser);
        }
    }

