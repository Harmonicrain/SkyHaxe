package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GroupDetailsChangedMessageParser;

     class GroupDetailsChangedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GroupDetailsChangedMessageParser);
        }

        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return cast(_parser, GroupDetailsChangedMessageParser).groupId;
        }
    }

