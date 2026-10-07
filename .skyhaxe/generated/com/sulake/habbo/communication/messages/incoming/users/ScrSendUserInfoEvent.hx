package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ScrSendUserInfoMessageParser;

     class ScrSendUserInfoEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ScrSendUserInfoMessageParser);
        }

        public function getParser():ScrSendUserInfoMessageParser
        {
            return Std.downcast(this._parser , ScrSendUserInfoMessageParser);
        }
    }

