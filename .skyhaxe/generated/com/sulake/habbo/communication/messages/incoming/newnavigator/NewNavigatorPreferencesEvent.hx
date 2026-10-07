package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NewNavigatorPreferencesParser;

     class NewNavigatorPreferencesEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NewNavigatorPreferencesParser);
        }

        public function getParser():NewNavigatorPreferencesParser
        {
            return Std.downcast(parser , NewNavigatorPreferencesParser);
        }
    }

