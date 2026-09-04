package com.sulake.habbo.communication.messages.parser.inventory.bots
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotInventoryMessageParser implements IMessageParser
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
            var _local_4:BotData;
            this._items = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new BotData(k);
                this._items.add(_local_4.id, _local_4);
                _local_3++;
            }
            return true;
        }

        public var items(get,never):Map;
function  get_items():Map
        {
            return this._items;
        }

	public function new() {}
    }

