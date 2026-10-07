package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.RoomEventMessageParser;

     class RoomEventEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomEventMessageParser);
        }

        public function getParser():RoomEventMessageParser
        {
            return Std.downcast(this._parser , RoomEventMessageParser);
        }
    }

