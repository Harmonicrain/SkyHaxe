package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.UserEventCatsMessageParser;

     class UserEventCatsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserEventCatsMessageParser);
        }

        public function getParser():UserEventCatsMessageParser
        {
            return Std.downcast(this._parser , UserEventCatsMessageParser);
        }
    }

