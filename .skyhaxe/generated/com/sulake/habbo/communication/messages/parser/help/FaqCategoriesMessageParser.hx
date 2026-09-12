package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FaqCategoriesMessageParser implements IMessageParser
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
            var category:Map = null;
            var category_id = 0;
            var name:String = null;
            var count = 0;
            this._data = new Map();
            var category_amount= k.readInteger();
            var iterator = 0;
            while (iterator < category_amount)
            {
                category = new Map();
                category_id = k.readInteger();
                name = k.readString();
                count = k.readInteger();
                category.add("name", name);
                category.add("count", count);
                this._data.add(category_id, category);
                iterator++;
            }
            return true;
        }

	public function new() {}
    }

