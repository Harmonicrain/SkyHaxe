package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.PostThreadMessageParser;

     class PostThreadMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PostThreadMessageParser);
        }

        public function getParser():PostThreadMessageParser
        {
            return Std.downcast(this._parser , PostThreadMessageParser);
        }
    }

