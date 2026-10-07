package com.sulake.habbo.communication.messages.incoming.landingview.votes
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.landingview.votes.CommunityVoteReceivedParser;

     class CommunityGoalVoteMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CommunityVoteReceivedParser);
        }

        public function getParser():CommunityVoteReceivedParser
        {
            return Std.downcast(_parser , CommunityVoteReceivedParser);
        }
    }

