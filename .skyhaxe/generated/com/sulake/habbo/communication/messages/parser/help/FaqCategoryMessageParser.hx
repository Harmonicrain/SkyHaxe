package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FaqCategoryMessageParser implements IMessageParser
    {
        var _categoryId:Int = 0;
        var _description:String;
        var _data:Map;


        public var categoryId(get,never):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

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
            this._categoryId = -1;
            this._description = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3 = 0;
            var _local_4:String = null;
            this._data = new Map();
            this._categoryId = k.readInteger();
            this._description = k.readString();
            var _local_2= k.readInteger();
            var _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_3 = k.readInteger();
                _local_4 = k.readString();
                this._data.add(_local_3, _local_4);
                _local_5++;
            }
            return true;
        }

	public function new() {}
    }

