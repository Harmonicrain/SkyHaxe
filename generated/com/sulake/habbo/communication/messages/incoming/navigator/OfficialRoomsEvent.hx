package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.OfficialRoomsMessageParser;

     class OfficialRoomsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OfficialRoomsMessageParser);
        }

        public function getParser():OfficialRoomsMessageParser
        {
            return Std.downcast(this._parser , OfficialRoomsMessageParser);
        }
    }

