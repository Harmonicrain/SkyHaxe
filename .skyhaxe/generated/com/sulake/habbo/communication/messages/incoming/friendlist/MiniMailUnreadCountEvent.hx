package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.MiniMailUnreadCountMessageParser;

     class MiniMailUnreadCountEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MiniMailUnreadCountMessageParser);
        }

        public function getParser():MiniMailUnreadCountMessageParser
        {
            return Std.downcast(_parser , MiniMailUnreadCountMessageParser);
        }
    }

