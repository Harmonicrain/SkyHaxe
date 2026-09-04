package com.sulake.habbo.communication.messages.parser.inventory.clothing
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_9021 implements IMessageParser 
    {
        var _itemId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._itemId = k.readInteger();
            return true;
        }

        public var itemId(get,never):Int;
function  get_itemId():Int
        {
            return this._itemId;
        }

	public function new() {}
    }

