package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorMetaDataParser;

     class NavigatorMetaDataEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, NavigatorMetaDataParser);
        }

        public function getParser():NavigatorMetaDataParser
        {
            return Std.downcast(parser , NavigatorMetaDataParser);
        }
    }

