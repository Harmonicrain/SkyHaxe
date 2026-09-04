package com.sulake.habbo.communication.messages.incoming.callforhelp
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.callforhelp.CfhTopicsInitMessageParser;

     class CfhTopicsInitEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CfhTopicsInitMessageParser);
        }

        public function getParser():CfhTopicsInitMessageParser
        {
            return Std.downcast(_parser , CfhTopicsInitMessageParser);
        }
    }

