package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.FindFriendsProcessResultMessageParser;

     class FindFriendsProcessResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FindFriendsProcessResultMessageParser);
        }

        public var success(get,never):Bool;
public function  get_success():Bool
        {
            return cast(_parser, FindFriendsProcessResultMessageParser).success;
        }
    }

