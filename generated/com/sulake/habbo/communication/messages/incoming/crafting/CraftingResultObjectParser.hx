package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CraftingResultObjectParser 
    {
        var _recipeName:String;
        var _itemName:String;

        public function new(k:IMessageDataWrapper)
        {
            this._recipeName = k.readString();
            this._itemName = k.readString();
        }

        public var recipeName(get,never):String;
function  get_recipeName():String
        {
            return this._recipeName;
        }

        public var itemName(get,never):String;
function  get_itemName():String
        {
            return this._itemName;
        }
    }

