package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.FriendListUpdateMessageParser;

     class FriendListUpdateEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FriendListUpdateMessageParser);
        }

        public function getParser():FriendListUpdateMessageParser
        {
            return Std.downcast(this._parser , FriendListUpdateMessageParser);
        }
    }

