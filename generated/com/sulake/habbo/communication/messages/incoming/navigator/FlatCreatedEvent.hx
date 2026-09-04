package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.FlatCreatedMessageParser;

     class FlatCreatedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FlatCreatedMessageParser);
        }

        public function getParser():FlatCreatedMessageParser
        {
            return Std.downcast(this._parser , FlatCreatedMessageParser);
        }
    }

