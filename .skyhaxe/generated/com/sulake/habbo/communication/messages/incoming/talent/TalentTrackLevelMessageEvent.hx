package com.sulake.habbo.communication.messages.incoming.talent
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrackLevelMessageParser;

     class TalentTrackLevelMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, TalentTrackLevelMessageParser);
        }

        public function getParser():TalentTrackLevelMessageParser
        {
            return Std.downcast(_parser , TalentTrackLevelMessageParser);
        }
    }

