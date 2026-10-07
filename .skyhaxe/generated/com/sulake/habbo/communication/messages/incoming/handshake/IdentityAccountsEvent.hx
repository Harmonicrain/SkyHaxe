package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.IdentityAccountsParser;

     class IdentityAccountsEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, IdentityAccountsParser);
        }

        public function getParser():IdentityAccountsParser
        {
            return Std.downcast(this._parser , IdentityAccountsParser);
        }
    }

