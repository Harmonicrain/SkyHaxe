package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.FriendNotificationMessageParser;

     class FriendNotificationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FriendNotificationMessageParser);
        }

        public function getParser():FriendNotificationMessageParser
        {
            return Std.downcast(_parser , FriendNotificationMessageParser);
        }
    }

