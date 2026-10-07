package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.RoomInviteErrorMessageParser;

     class RoomInviteErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomInviteErrorMessageParser);
        }

        public function getParser():RoomInviteErrorMessageParser
        {
            return Std.downcast(this._parser , RoomInviteErrorMessageParser);
        }
    }

