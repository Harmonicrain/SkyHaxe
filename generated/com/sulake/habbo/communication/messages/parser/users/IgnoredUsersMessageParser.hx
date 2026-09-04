package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IgnoredUsersMessageParser implements IMessageParser
    {
        var _ignoredUsers:Array<ASAny> = null;

        public function new()
        {
            this._ignoredUsers = [];
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._ignoredUsers = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._ignoredUsers.push(k.readString());
                _local_3++;
            }
            return true;
        }

        public var ignoredUsers(get,never):Array<ASAny>;
function  get_ignoredUsers():Array<ASAny>
        {
            return this._ignoredUsers.slice();
        }
    }

