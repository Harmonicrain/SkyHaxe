package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OneWayDoorStatusMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _status:Int = 0;


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        public function flush():Bool
        {
            this._id = -1;
            this._status = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._id = k.readInteger();
            this._status = k.readInteger();
            return true;
        }

	public function new() {}
    }

