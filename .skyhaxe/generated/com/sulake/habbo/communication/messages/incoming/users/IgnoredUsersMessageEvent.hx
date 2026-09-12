package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.IgnoredUsersMessageParser;

     class IgnoredUsersMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IgnoredUsersMessageParser);
        }

        public var ignoredUsers(get,never):Array<ASAny>;
public function  get_ignoredUsers():Array<ASAny>
        {
            return Std.downcast(_parser , IgnoredUsersMessageParser).ignoredUsers;
        }
    }

