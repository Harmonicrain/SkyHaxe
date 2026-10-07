package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.HabboSearchResultMessageParser;

     class HabboSearchResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboSearchResultMessageParser);
        }

        public function getParser():HabboSearchResultMessageParser
        {
            return Std.downcast(this._parser , HabboSearchResultMessageParser);
        }
    }

