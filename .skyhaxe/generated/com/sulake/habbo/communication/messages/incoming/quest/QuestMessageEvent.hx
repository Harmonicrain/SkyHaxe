package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.QuestParser;

     class QuestMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, QuestParser);
        }

        public function getParser():QuestParser
        {
            return Std.downcast(_parser , QuestParser);
        }
    }

