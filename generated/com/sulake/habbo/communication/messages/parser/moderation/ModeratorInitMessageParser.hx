package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorInitMessageParser implements IMessageParser
    {
        var _data:ModeratorInitData;


        public function flush():Bool
        {
            if (this._data != null)
            {
                this._data.dispose();
                this._data = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new ModeratorInitData(k);
            return true;
        }

        public var data(get,never):ModeratorInitData;
function  get_data():ModeratorInitData
        {
            return this._data;
        }

	public function new() {}
    }

