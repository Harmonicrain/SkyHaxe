package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.SeasonalQuestsParser;

     class SeasonalQuestsMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SeasonalQuestsParser);
        }

        public function getParser():SeasonalQuestsParser
        {
            return Std.downcast(_parser , SeasonalQuestsParser);
        }
    }

