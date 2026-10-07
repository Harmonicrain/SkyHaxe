package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorLiftedRoomsParser;

     class NavigatorLiftedRoomsEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, NavigatorLiftedRoomsParser);
        }

        public function getParser():NavigatorLiftedRoomsParser
        {
            return Std.downcast(parser , NavigatorLiftedRoomsParser);
        }
    }

