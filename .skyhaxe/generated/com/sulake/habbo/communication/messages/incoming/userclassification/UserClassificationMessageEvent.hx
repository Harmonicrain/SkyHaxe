package com.sulake.habbo.communication.messages.incoming.userclassification
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userclassification.UserClassificationMessageParser;

     class UserClassificationMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UserClassificationMessageParser);
        }

        public function getParser():UserClassificationMessageParser
        {
            return Std.downcast(_parser , UserClassificationMessageParser);
        }
    }

