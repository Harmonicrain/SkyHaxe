package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.ExtendedProfileData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ExtendedProfileMessageParser implements IMessageParser 
    {
        var _data:ExtendedProfileData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new ExtendedProfileData(k);
            return true;
        }

        public var data(get,never):ExtendedProfileData;
function  get_data():ExtendedProfileData
        {
            return this._data;
        }

	public function new() {}
    }

