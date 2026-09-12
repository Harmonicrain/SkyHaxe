package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.GetGuestRoomResultMessageParser;

     class GetGuestRoomResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GetGuestRoomResultMessageParser);
        }

        public function getParser():GetGuestRoomResultMessageParser
        {
            return Std.downcast(this._parser , GetGuestRoomResultMessageParser);
        }
    }

