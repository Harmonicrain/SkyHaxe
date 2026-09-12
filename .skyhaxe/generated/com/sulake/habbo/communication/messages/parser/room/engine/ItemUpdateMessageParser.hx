package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ItemUpdateMessageParser implements IMessageParser
    {
        var _item:ItemMessageData = null;


        public function flush():Bool
        {
            this._item = null;
            return true;
        }

        public var data(get,never):ItemMessageData;
public function  get_data():ItemMessageData
        {
            var k= this._item;
            if (k != null)
            {
                k.setReadOnly();
            }
            return k;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._item = ItemDataParser.parseItemData(k);
            return true;
        }

	public function new() {}
    }

