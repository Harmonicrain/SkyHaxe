package com.sulake.habbo.communication.messages.incoming.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackProgressMessageParser;

     class RewardTrackProgressMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, RewardTrackProgressMessageParser);
        }

        public function getParser():RewardTrackProgressMessageParser
        {
            return Std.downcast(_parser , RewardTrackProgressMessageParser);
        }
    }

