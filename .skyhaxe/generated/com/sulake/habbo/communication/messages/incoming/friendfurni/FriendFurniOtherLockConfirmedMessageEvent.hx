package com.sulake.habbo.communication.messages.incoming.friendfurni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendfurni.FriendFurniOtherLockConfirmedMessageParser;

     class FriendFurniOtherLockConfirmedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FriendFurniOtherLockConfirmedMessageParser);
        }

        public function getParser():FriendFurniOtherLockConfirmedMessageParser
        {
            return Std.downcast(_parser , FriendFurniOtherLockConfirmedMessageParser);
        }
    }

