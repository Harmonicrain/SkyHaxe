package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.MessengerInitMessageParser;

     class MessengerInitEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MessengerInitMessageParser);
        }

        public function getParser():MessengerInitMessageParser
        {
            return Std.downcast(this._parser , MessengerInitMessageParser);
        }
    }

