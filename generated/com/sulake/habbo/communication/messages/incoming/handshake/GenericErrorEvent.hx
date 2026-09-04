package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.GenericErrorParser;

     class GenericErrorEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GenericErrorParser);
        }

        public function getParser():GenericErrorParser
        {
            return Std.downcast(this._parser , GenericErrorParser);
        }
    }

