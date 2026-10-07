package com.sulake.habbo.communication.messages.incoming.session
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.session.FurniDataReloadMessageParser;

     class FurniDataReloadMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FurniDataReloadMessageParser);
        }

        public function getParser():FurniDataReloadMessageParser
        {
            return Std.downcast(this._parser , FurniDataReloadMessageParser);
        }
    }

