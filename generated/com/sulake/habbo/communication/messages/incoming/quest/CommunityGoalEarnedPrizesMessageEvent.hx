package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.quest.CommunityGoalEarnedPrizesParser;

     class CommunityGoalEarnedPrizesMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CommunityGoalEarnedPrizesParser);
        }

        public function getParser():CommunityGoalEarnedPrizesParser
        {
            return Std.downcast(this._parser , CommunityGoalEarnedPrizesParser);
        }
    }

