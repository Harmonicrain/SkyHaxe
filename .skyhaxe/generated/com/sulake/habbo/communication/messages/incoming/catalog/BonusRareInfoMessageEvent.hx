package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.BonusRareInfoMessageParser;

     class BonusRareInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BonusRareInfoMessageParser);
        }

        public function getParser():BonusRareInfoMessageParser
        {
            return Std.downcast(this._parser , BonusRareInfoMessageParser);
        }
    }

