package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.PostMessageMessageParser;

     class PostMessageMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PostMessageMessageParser);
        }

        public function getParser():PostMessageMessageParser
        {
            return Std.downcast(this._parser , PostMessageMessageParser);
        }
    }

