package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.MiniMailNewMessageMessageParser;

     class MiniMailNewMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MiniMailNewMessageMessageParser);
        }

        public function getParser():MiniMailNewMessageMessageParser
        {
            return Std.downcast(_parser , MiniMailNewMessageMessageParser);
        }
    }

