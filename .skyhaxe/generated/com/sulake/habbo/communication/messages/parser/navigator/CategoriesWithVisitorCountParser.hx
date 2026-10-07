package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.CategoriesWithVisitorCountData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CategoriesWithVisitorCountParser implements IMessageParser
    {
        var _data:CategoriesWithVisitorCountData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new CategoriesWithVisitorCountData(k);
            return true;
        }

        public var data(get,never):CategoriesWithVisitorCountData;
public function  get_data():CategoriesWithVisitorCountData
        {
            return this._data;
        }

	public function new() {}
    }

