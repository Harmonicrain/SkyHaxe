package com.sulake.habbo.communication.messages.incoming.talent
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrackMessageParser;

     class TalentTrackMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, TalentTrackMessageParser);
        }

        public function getParser():TalentTrackMessageParser
        {
            return Std.downcast(_parser , TalentTrackMessageParser);
        }
    }

