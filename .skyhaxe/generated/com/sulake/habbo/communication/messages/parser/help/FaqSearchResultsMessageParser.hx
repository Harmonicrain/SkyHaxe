package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FaqSearchResultsMessageParser implements IMessageParser
    {
        var _data:Map;


        public var data(get,never):Map;
public function  get_data():Map
        {
            return this._data;
        }

        public function flush():Bool
        {
            if (this._data != null)
            {
                this._data.dispose();
            }
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            var _local_3:String = null;
            this._data = new Map();
            var _local_4= k.readInteger();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_2 = k.readInteger();
                _local_3 = k.readString();
                this._data.add(_local_2, _local_3);
                _local_5++;
            }
            return true;
        }

	public function new() {}
    }

