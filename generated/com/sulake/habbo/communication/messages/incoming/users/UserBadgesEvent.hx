package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.HabboUserBadgesMessageParser;

     class UserBadgesEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, HabboUserBadgesMessageParser);
        }

        public var badges(get,never):Array<ASAny>;
function  get_badges():Array<ASAny>
        {
            return Std.downcast(_parser , HabboUserBadgesMessageParser).badges;
        }

        public var userId(get,never):Int;
function  get_userId():Int
        {
            return Std.downcast(_parser , HabboUserBadgesMessageParser).userId;
        }
    }

