package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.QuestCancelledParser;

     class QuestCancelledMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, QuestCancelledParser);
        }

        public function getParser():QuestCancelledParser
        {
            return Std.downcast(_parser , QuestCancelledParser);
        }
    }

