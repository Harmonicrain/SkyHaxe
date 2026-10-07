package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.NewConsoleMessageMessageParser;

     class NewConsoleMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NewConsoleMessageMessageParser);
        }

        public function getParser():NewConsoleMessageMessageParser
        {
            return Std.downcast(this._parser , NewConsoleMessageMessageParser);
        }
    }

