package com.sulake.habbo.communication.messages.incoming.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackClaimResultMessageParser;

     class RewardTrackClaimResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, RewardTrackClaimResultMessageParser);
        }

        public function getParser():RewardTrackClaimResultMessageParser
        {
            return Std.downcast(_parser , RewardTrackClaimResultMessageParser);
        }
    }

