package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.MessengerErrorMessageParser;

     class MessengerErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MessengerErrorMessageParser);
        }

        public function getParser():MessengerErrorMessageParser
        {
            return Std.downcast(this._parser , MessengerErrorMessageParser);
        }
    }

