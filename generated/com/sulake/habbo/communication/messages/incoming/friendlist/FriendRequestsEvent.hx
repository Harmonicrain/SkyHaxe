package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.FriendRequestsMessageParser;

     class FriendRequestsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FriendRequestsMessageParser);
        }

        public function getParser():FriendRequestsMessageParser
        {
            return Std.downcast(this._parser , FriendRequestsMessageParser);
        }
    }

