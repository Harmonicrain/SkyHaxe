package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.GetForumsListMessageParser;

     class ForumsListMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GetForumsListMessageParser);
        }

        public function getParser():GetForumsListMessageParser
        {
            return cast(this._parser, GetForumsListMessageParser);
        }
    }

