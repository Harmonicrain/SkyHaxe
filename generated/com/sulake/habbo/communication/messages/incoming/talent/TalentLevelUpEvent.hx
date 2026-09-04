package com.sulake.habbo.communication.messages.incoming.talent
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.talent.TalentLevelUpMessageParser;

     class TalentLevelUpEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, TalentLevelUpMessageParser);
        }

        public function getParser():TalentLevelUpMessageParser
        {
            return Std.downcast(_parser , TalentLevelUpMessageParser);
        }
    }

