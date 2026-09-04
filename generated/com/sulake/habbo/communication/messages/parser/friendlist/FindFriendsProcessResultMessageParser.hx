package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FindFriendsProcessResultMessageParser implements IMessageParser
    {
        var _success:Bool = false;


        public var success(get,never):Bool;
function  get_success():Bool
        {
            return this._success;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._success = k.readBoolean();
            return true;
        }

	public function new() {}
    }

