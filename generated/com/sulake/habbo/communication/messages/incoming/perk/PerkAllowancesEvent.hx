package com.sulake.habbo.communication.messages.incoming.perk
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.perk.PerkAllowancesMessageParser;

     class PerkAllowancesEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PerkAllowancesMessageParser);
        }

        public function getParser():PerkAllowancesMessageParser
        {
            return Std.downcast(_parser , PerkAllowancesMessageParser);
        }
    }

