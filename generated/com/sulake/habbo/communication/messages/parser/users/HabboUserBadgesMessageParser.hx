package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboUserBadgesMessageParser implements IMessageParser
    {
        var _userId:Int = 0;
        var _badges:Array<ASAny>;


        public function flush():Bool
        {
            this._userId = -1;
            this._badges = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var slotId:Int;
            var badgeCode:String;
            this._userId = k.readInteger();
            var count= k.readInteger();
            var index = 0;
            while (index < count)
            {
                slotId = k.readInteger();
                badgeCode = k.readString();
                this._badges.push(badgeCode);
                index++;
            }
            return true;
        }

        public var badges(get,never):Array<ASAny>;
function  get_badges():Array<ASAny>
        {
            return this._badges;
        }

        public var userId(get,never):Int;
function  get_userId():Int
        {
            return this._userId;
        }

	public function new() {}
    }

