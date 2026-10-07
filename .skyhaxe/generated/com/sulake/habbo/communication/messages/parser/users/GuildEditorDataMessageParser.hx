package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditorData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildEditorDataMessageParser implements IMessageParser
    {
        var _data:GuildEditorData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new GuildEditorData(k);
            return true;
        }

        public var data(get,never):GuildEditorData;
public function  get_data():GuildEditorData
        {
            return this._data;
        }

	public function new() {}
    }

