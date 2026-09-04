package com.sulake.habbo.communication.messages.incoming.rewardtrack
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTracksMessageParser;

     class RewardTracksMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, RewardTracksMessageParser);
        }

        public function getParser():RewardTracksMessageParser
        {
            return Std.downcast(_parser , RewardTracksMessageParser);
        }
    }

