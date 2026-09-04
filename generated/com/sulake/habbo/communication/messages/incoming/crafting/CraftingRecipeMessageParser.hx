package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CraftingRecipeMessageParser implements IMessageParser 
    {
        var _ingredients:Vector<CraftinRecipeIngredientParser>;

        public function new()
        {
            this._ingredients = new Vector<CraftinRecipeIngredientParser>(0);
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
			var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._ingredients.push(new CraftinRecipeIngredientParser(k));
                _local_3++;
            }
            return true;
        }

        public function flush():Bool
        {
            this._ingredients = new Vector<CraftinRecipeIngredientParser>(0);
            return true;
        }

        public var ingredients(get,never):Vector<CraftinRecipeIngredientParser>;
function  get_ingredients():Vector<CraftinRecipeIngredientParser>
        {
            return this._ingredients;
        }
    }

