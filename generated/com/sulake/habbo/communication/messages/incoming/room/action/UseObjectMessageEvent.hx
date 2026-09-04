package com.sulake.habbo.communication.messages.incoming.room.action
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.action.UseObjectMessageParser;

     class UseObjectMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UseObjectMessageParser);
        }

        public function getParser():UseObjectMessageParser
        {
            return Std.downcast(_parser , UseObjectMessageParser);
        }
    }

