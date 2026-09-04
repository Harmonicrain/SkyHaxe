package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ItemRemoveMessageParser implements IMessageParser
    {
        var _itemId:Int = 0;
        var _pickerId:Int = -1;


        public var itemId(get,never):Int;
function  get_itemId():Int
        {
            return this._itemId;
        }

        public var pickerId(get,never):Int;
function  get_pickerId():Int
        {
            return this._pickerId;
        }

        public function flush():Bool
        {
            this._itemId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._itemId = ASCompat.toInt(k.readString());
            this._pickerId = k.readInteger();
            return true;
        }

	public function new() {}
    }

