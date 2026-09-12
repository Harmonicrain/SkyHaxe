package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.RoomRatingMessageParser;

     class RoomRatingEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomRatingMessageParser);
        }

        public function getParser():RoomRatingMessageParser
        {
            return Std.downcast(this._parser , RoomRatingMessageParser);
        }
    }

