package com.sulake.habbo.communication.messages.parser.inventory.furni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurniListRemoveParser implements IMessageParser 
    {
        var _itemId:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._itemId = k.readInteger();
            return true;
        }

        public function flush():Bool
        {
            return true;
        }

        public var stripId(get,never):Int;
function  get_stripId():Int
        {
            return this._itemId;
        }

	public function new() {}
    }

