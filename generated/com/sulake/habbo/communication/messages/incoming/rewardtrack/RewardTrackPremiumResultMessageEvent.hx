package com.sulake.habbo.communication.messages.incoming.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackPremiumResultMessageParser;

     class RewardTrackPremiumResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, RewardTrackPremiumResultMessageParser);
        }

        public function getParser():RewardTrackPremiumResultMessageParser
        {
            return Std.downcast(_parser , RewardTrackPremiumResultMessageParser);
        }
    }

