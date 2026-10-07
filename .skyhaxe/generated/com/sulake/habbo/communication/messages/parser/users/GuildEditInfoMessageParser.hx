package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildEditInfoMessageParser implements IMessageParser
    {
        var _data:GuildEditData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new GuildEditData(k);
            return true;
        }

        public var data(get,never):GuildEditData;
public function  get_data():GuildEditData
        {
            return this._data;
        }

	public function new() {}
    }

