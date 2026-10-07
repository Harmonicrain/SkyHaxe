package com.sulake.habbo.communication.messages.incoming.competition
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.competition.IsUserPartOfCompetitionMessageParser;

     class IsUserPartOfCompetitionMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IsUserPartOfCompetitionMessageParser);
        }

        public function getParser():IsUserPartOfCompetitionMessageParser
        {
            return Std.downcast(_parser , IsUserPartOfCompetitionMessageParser);
        }
    }

