package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CraftinRecipeIngredientParser 
    {
        var _count:Int = 0;
        var _itemName:String;

        public function new(k:IMessageDataWrapper)
        {
            this._count = k.readInteger();
            this._itemName = k.readString();
        }

        public var count(get,never):Int;
function  get_count():Int
        {
            return this._count;
        }

        public var itemName(get,never):String;
function  get_itemName():String
        {
            return this._itemName;
        }
    }

