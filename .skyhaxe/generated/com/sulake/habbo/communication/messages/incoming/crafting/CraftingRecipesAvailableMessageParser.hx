package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CraftingRecipesAvailableMessageParser implements IMessageParser 
    {
        var _hasRecipes:Bool = false;
        var _count:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._count = k.readInteger();
            this._hasRecipes = k.readBoolean();
            return true;
        }

        public function flush():Bool
        {
            this._count = 0;
            this._hasRecipes = false;
            return true;
        }

        public var count(get,never):Int;
public function  get_count():Int
        {
            return this._count;
        }

        public var hasRecipes(get,never):Bool;
public function  get_hasRecipes():Bool
        {
            return this._hasRecipes;
        }

	public function new() {}
    }

