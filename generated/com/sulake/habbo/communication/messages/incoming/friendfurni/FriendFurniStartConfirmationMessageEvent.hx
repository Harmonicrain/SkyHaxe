package com.sulake.habbo.communication.messages.incoming.friendfurni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendfurni.FriendFurniStartConfirmationMessageParser;

     class FriendFurniStartConfirmationMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FriendFurniStartConfirmationMessageParser);
        }

        public function getParser():FriendFurniStartConfirmationMessageParser
        {
            return Std.downcast(_parser , FriendFurniStartConfirmationMessageParser);
        }
    }

