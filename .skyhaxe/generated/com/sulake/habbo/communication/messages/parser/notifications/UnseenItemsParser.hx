package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UnseenItemsParser implements IMessageParser
    {
        var _items:Map;


        public function flush():Bool
        {
            if (this._items != null)
            {
                this._items.dispose();
                this._items = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            var _local_3:Array<ASAny> = null;
            var _local_6 = 0;
            var _local_7 = 0;
            this._items = new Map();
            var _local_4= k.readInteger();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_2 = k.readInteger();
                _local_3 = [];
                _local_6 = k.readInteger();
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    _local_3.push(k.readInteger());
                    _local_7++;
                }
                this._items.add(_local_2, _local_3);
                _local_5++;
            }
            return true;
        }

        public function _Str_17858():Array<ASAny>
        {
            return this._items.getKeys();
        }

        public function _Str_24396(k:Int):Array<ASAny>
        {
            return this._items.getValue(k);
        }

	public function new() {}
    }

