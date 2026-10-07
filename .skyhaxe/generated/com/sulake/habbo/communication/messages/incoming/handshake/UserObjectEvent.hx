package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.UserObjectMessageParser;

     class UserObjectEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UserObjectMessageParser);
        }

        public function getParser():UserObjectMessageParser
        {
            return Std.downcast(this._parser , UserObjectMessageParser);
        }
    }

