package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.QuestDailyParser;

     class QuestDailyMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, QuestDailyParser);
        }

        public function getParser():QuestDailyParser
        {
            return Std.downcast(_parser , QuestDailyParser);
        }
    }

