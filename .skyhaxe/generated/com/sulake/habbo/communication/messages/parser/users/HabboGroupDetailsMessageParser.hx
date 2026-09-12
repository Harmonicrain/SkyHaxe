package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboGroupDetailsMessageParser implements IMessageParser
    {
        var _data:HabboGroupDetailsData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new HabboGroupDetailsData(k);
            return true;
        }

        public var data(get,never):HabboGroupDetailsData;
public function  get_data():HabboGroupDetailsData
        {
            return this._data;
        }

	public function new() {}
    }

