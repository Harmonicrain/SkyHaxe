package com.sulake.habbo.communication.messages.parser.room.publicroom
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BusDoorMessageParser implements IMessageParser
    {
        var _open:Bool = false;

        public var open(get,never):Bool;
function  get_open():Bool
        {
            return this._open;
        }

        public function flush():Bool
        {
            this._open = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._open = k.readBoolean();
            return true;
        }

	public function new() {}
    }

