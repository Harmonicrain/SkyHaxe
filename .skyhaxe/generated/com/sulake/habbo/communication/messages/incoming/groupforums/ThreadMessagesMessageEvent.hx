package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.ThreadMessagesMessageParser;

     class ThreadMessagesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ThreadMessagesMessageParser);
        }

        public function getParser():ThreadMessagesMessageParser
        {
            return Std.downcast(this._parser , ThreadMessagesMessageParser);
        }
    }

