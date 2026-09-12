package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.AcceptFriendResultMessageParser;

     class AcceptFriendResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AcceptFriendResultMessageParser);
        }

        public function getParser():AcceptFriendResultMessageParser
        {
            return Std.downcast(this._parser , AcceptFriendResultMessageParser);
        }
    }

