package com.sulake.habbo.communication.messages.parser.inventory.furni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PostItPlacedParser implements IMessageParser 
    {
        var _id:Int = 0;
        var _itemsLeft:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._id = k.readInteger();
            this._itemsLeft = k.readInteger();
            return true;
        }

        public function flush():Bool
        {
            return true;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var itemsLeft(get,never):Int;
function  get_itemsLeft():Int
        {
            return this._itemsLeft;
        }

	public function new() {}
    }

