package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.CanCreateRoomEventMessageParser;

     class CanCreateRoomEventEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CanCreateRoomEventMessageParser);
        }

        public function getParser():CanCreateRoomEventMessageParser
        {
            return Std.downcast(this._parser , CanCreateRoomEventMessageParser);
        }
    }

