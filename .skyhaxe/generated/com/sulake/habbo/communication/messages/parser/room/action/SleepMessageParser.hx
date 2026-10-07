package com.sulake.habbo.communication.messages.parser.room.action
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SleepMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _sleeping:Bool = false;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var sleeping(get,never):Bool;
public function  get_sleeping():Bool
        {
            return this._sleeping;
        }

        public function flush():Bool
        {
            this._userId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._sleeping = k.readBoolean();
            return true;
        }

	public function new() {}
    }

