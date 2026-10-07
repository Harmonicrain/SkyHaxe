package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorSearchResultBlocksParser;

     class NavigatorSearchResultBlocksEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NavigatorSearchResultBlocksParser);
        }

        public function getParser():NavigatorSearchResultBlocksParser
        {
            return Std.downcast(parser , NavigatorSearchResultBlocksParser);
        }
    }

