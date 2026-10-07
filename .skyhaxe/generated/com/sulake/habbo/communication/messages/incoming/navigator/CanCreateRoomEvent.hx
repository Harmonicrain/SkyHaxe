package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.CanCreateRoomMessageParser;

     class CanCreateRoomEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CanCreateRoomMessageParser);
        }

        public function getParser():CanCreateRoomMessageParser
        {
            return Std.downcast(this._parser , CanCreateRoomMessageParser);
        }
    }

