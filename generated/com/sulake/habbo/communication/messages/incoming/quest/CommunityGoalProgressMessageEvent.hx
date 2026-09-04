package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.CommunityGoalProgressParser;

     class CommunityGoalProgressMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CommunityGoalProgressParser);
        }

        public function getParser():CommunityGoalProgressParser
        {
            return Std.downcast(_parser , CommunityGoalProgressParser);
        }
    }

