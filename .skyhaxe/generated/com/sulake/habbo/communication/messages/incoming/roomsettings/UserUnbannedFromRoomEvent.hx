package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.roomsettings.UserUnbannedFromRoomParser;

     class UserUnbannedFromRoomEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserUnbannedFromRoomParser);
        }

        public function getParser():UserUnbannedFromRoomParser
        {
            return Std.downcast(this._parser , UserUnbannedFromRoomParser);
        }
    }

