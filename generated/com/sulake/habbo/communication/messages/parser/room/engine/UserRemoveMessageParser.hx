package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserRemoveMessageParser implements IMessageParser
    {
        var _id:Int = 0;


        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public function flush():Bool
        {
            this._id = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._id = ASCompat.toInt(k.readString());
            return true;
        }

	public function new() {}
    }

