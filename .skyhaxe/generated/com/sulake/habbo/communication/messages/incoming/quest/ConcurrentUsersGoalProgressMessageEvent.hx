package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.ConcurrentUsersGoalProgressParser;

     class ConcurrentUsersGoalProgressMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, ConcurrentUsersGoalProgressParser);
        }

        public function getParser():ConcurrentUsersGoalProgressParser
        {
            return Std.downcast(_parser , ConcurrentUsersGoalProgressParser);
        }
    }

