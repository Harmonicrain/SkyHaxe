package com.sulake.habbo.communication.messages.incoming.callforhelp
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.callforhelp.CfhSanctionMessageParser;

     class CfhSanctionMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CfhSanctionMessageParser);
        }

        public function getParser():CfhSanctionMessageParser
        {
            return Std.downcast(_parser , CfhSanctionMessageParser);
        }
    }

