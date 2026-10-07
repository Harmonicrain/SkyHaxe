package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.UnreadForumsCountMessageParser;

     class UnreadForumsCountMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UnreadForumsCountMessageParser);
        }

        public function getParser():UnreadForumsCountMessageParser
        {
            return Std.downcast(this._parser , UnreadForumsCountMessageParser);
        }
    }

