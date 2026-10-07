package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GroupMembershipRequestedMessageParser;

     class GroupMembershipRequestedMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GroupMembershipRequestedMessageParser);
        }

        public function getParser():GroupMembershipRequestedMessageParser
        {
            return cast(_parser, GroupMembershipRequestedMessageParser);
        }
    }

