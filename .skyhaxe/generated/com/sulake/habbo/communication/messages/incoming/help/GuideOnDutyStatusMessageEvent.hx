package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideOnDutyStatusMessageParser;

     class GuideOnDutyStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideOnDutyStatusMessageParser);
        }

        public function getParser():GuideOnDutyStatusMessageParser
        {
            return Std.downcast(_parser , GuideOnDutyStatusMessageParser);
        }
    }

