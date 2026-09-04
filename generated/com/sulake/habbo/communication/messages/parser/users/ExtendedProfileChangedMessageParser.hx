package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ExtendedProfileChangedMessageParser implements IMessageParser
    {
        var _userId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userId = k.readInteger();
            return true;
        }

        public var userId(get,never):Int;
function  get_userId():Int
        {
            return this._userId;
        }

	public function new() {}
    }

