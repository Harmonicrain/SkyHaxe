package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorUserInfoData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorUserInfoMessageParser implements IMessageParser
    {
        var _data:ModeratorUserInfoData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new ModeratorUserInfoData(k);
            return true;
        }

        public var data(get,never):ModeratorUserInfoData;
public function  get_data():ModeratorUserInfoData
        {
            return this._data;
        }

	public function new() {}
    }

