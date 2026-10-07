package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.IsFirstLoginOfDayParser;

     class IsFirstLoginOfDayEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, IsFirstLoginOfDayParser);
        }

        public function getParser():IsFirstLoginOfDayParser
        {
            return Std.downcast(this._parser , IsFirstLoginOfDayParser);
        }
    }

