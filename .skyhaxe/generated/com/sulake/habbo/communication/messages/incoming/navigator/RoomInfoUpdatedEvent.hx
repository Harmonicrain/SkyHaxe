package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.RoomInfoUpdatedMessageParser;

     class RoomInfoUpdatedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomInfoUpdatedMessageParser);
        }

        public function getParser():RoomInfoUpdatedMessageParser
        {
            return Std.downcast(this._parser , RoomInfoUpdatedMessageParser);
        }
    }

