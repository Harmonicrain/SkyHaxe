package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.NewFriendRequestMessageParser;

     class NewFriendRequestEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NewFriendRequestMessageParser);
        }

        public function getParser():NewFriendRequestMessageParser
        {
            return Std.downcast(this._parser , NewFriendRequestMessageParser);
        }
    }

