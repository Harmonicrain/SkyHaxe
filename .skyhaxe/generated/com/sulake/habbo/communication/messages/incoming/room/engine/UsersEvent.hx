package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.UsersMessageParser;

     class UsersEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UsersMessageParser);
        }

        public function getParser():UsersMessageParser
        {
            return Std.downcast(_parser , UsersMessageParser);
        }
    }

