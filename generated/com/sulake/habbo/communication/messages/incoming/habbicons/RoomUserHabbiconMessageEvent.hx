package com.sulake.habbo.communication.messages.incoming.habbicons
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.RoomUserHabbiconMessageParser;

     class RoomUserHabbiconMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, RoomUserHabbiconMessageParser);
        }

        public function getParser():RoomUserHabbiconMessageParser
        {
            return Std.downcast(this._parser , RoomUserHabbiconMessageParser);
        }
    }

