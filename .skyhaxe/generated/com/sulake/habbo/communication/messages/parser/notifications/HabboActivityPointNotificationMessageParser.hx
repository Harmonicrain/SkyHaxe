package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboActivityPointNotificationMessageParser implements IMessageParser
    {
        var _amount:Int = 0;
        var _change:Int = 0;
        var _type:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._amount = k.readInteger();
            this._change = k.readInteger();
            this._type = k.readInteger();
            return true;
        }

        public var amount(get,never):Int;
public function  get_amount():Int
        {
            return this._amount;
        }

        public var change(get,never):Int;
public function  get_change():Int
        {
            return this._change;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

	public function new() {}
    }

