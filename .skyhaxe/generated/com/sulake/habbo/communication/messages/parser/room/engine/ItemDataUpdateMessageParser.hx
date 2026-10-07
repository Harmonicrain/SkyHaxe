package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ItemDataUpdateMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _itemData:String;


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var itemData(get,never):String;
public function  get_itemData():String
        {
            return this._itemData;
        }

        public function flush():Bool
        {
            this._id = 0;
            this._itemData = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= k.readString();
            this._id = ASCompat.toInt(_local_2);
            this._itemData = k.readString();
            return true;
        }

	public function new() {}
    }

