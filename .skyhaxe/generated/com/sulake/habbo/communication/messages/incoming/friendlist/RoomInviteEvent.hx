package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.RoomInviteMessageParser;

     class RoomInviteEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomInviteMessageParser);
        }

        public function getParser():RoomInviteMessageParser
        {
            return Std.downcast(this._parser , RoomInviteMessageParser);
        }
    }

