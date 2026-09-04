package com.sulake.habbo.communication.messages.parser.room.permissions
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class YouAreControllerMessageParser implements IMessageParser
    {
        var _roomControllerLevel:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._roomControllerLevel = k.readInteger();
            return true;
        }

        public var roomControllerLevel(get,never):Int;
function  get_roomControllerLevel():Int
        {
            return this._roomControllerLevel;
        }

	public function new() {}
    }

