package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.InstantMessageErrorMessageParser;

     class InstantMessageErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, InstantMessageErrorMessageParser);
        }

        public function getParser():InstantMessageErrorMessageParser
        {
            return Std.downcast(this._parser , InstantMessageErrorMessageParser);
        }
    }

