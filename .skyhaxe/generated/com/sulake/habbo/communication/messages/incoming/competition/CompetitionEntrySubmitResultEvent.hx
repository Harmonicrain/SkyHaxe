package com.sulake.habbo.communication.messages.incoming.competition
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.competition.CompetitionEntrySubmitResultMessageParser;

     class CompetitionEntrySubmitResultEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CompetitionEntrySubmitResultMessageParser);
        }

        public function getParser():CompetitionEntrySubmitResultMessageParser
        {
            return Std.downcast(_parser , CompetitionEntrySubmitResultMessageParser);
        }
    }

