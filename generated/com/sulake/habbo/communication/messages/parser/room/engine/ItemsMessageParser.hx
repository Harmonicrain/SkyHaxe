package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemMessageData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ItemsMessageParser implements IMessageParser 
    {
        var _items:Array<ASAny>;

        public function new()
        {
            this._items = [];
        }

        public function flush():Bool
        {
            this._items = [];
            return true;
        }

        public function getItemCount():Int
        {
            return this._items.length;
        }

        public function getItem(k:Int):ItemMessageData
        {
            if (((k < 0) || (k >= this.getItemCount())))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._items[k] , ItemMessageData);
            if (_local_2 != null)
            {
                _local_2.setReadOnly();
            }
            return _local_2;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var iterator:Int;
            var ownerId:Int;
            var ownerName:String;
            var item:ItemMessageData;
            if (k == null)
            {
                return false;
            }
            this._items = [];
            var owners= new Map();
            var ownersAmount= k.readInteger();
            iterator = 0;
            while (iterator < ownersAmount)
            {
                ownerId = k.readInteger();
                ownerName = k.readString();
                owners.add(ownerId, ownerName);
                iterator++;
            }
            var items= k.readInteger();
            Logger.log([(("We have: " + items) + " items")]);
            iterator = 0;
            while (iterator < items)
            {
                item = ItemDataParser.parseItemData(k);
                item.ownerName = owners.getValue(item.ownerId);
                this._items.push(item);
                iterator++;
            }
            return true;
        }
    }

