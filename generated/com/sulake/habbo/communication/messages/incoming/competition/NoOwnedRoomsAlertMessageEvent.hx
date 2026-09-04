package com.sulake.habbo.communication.messages.incoming.competition
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.competition.NoOwnedRoomsAlertMessageParser;

     class NoOwnedRoomsAlertMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NoOwnedRoomsAlertMessageParser);
        }

        public function getParser():NoOwnedRoomsAlertMessageParser
        {
            return Std.downcast(_parser , NoOwnedRoomsAlertMessageParser);
        }
    }

