package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorSavedSearchesParser;

     class NavigatorSavedSearchesEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, NavigatorSavedSearchesParser);
        }

        public function getParser():NavigatorSavedSearchesParser
        {
            return Std.downcast(parser , NavigatorSavedSearchesParser);
        }
    }

