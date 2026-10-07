package com.sulake.habbo.communication.messages.incoming.friendfurni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendfurni.FriendFurniCancelLockMessageParser;

     class FriendFurniCancelLockMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FriendFurniCancelLockMessageParser);
        }

        public function getParser():FriendFurniCancelLockMessageParser
        {
            return Std.downcast(_parser , FriendFurniCancelLockMessageParser);
        }
    }

