package com.sulake.habbo.communication.messages.parser.newnavigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CollapsedCategoriesMessageParser implements IMessageParser 
    {
        var _collapsedCategories:Vector<String>;


        public function flush():Bool
        {
            this._collapsedCategories = new Vector<String>(0);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._collapsedCategories.push(k.readString());
                _local_3++;
            }
            return true;
        }

        public var _Str_8273(get,never):Vector<String>;
public function  get__Str_8273():Vector<String>
        {
            return this._collapsedCategories;
        }

	public function new() {}
    }

