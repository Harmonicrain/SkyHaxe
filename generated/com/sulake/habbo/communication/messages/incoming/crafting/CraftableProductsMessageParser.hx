package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CraftableProductsMessageParser implements IMessageParser 
    {
        var _recipes:Vector<CraftingResultObjectParser>;
        var _ingredients:Vector<String>;

        public function new()
        {
            this._recipes = new Vector<CraftingResultObjectParser>(0);
            this._ingredients = new Vector<String>(0);
        }

        public function flush():Bool
        {
            this._recipes = new Vector<CraftingResultObjectParser>(0);
            this._ingredients = new Vector<String>(0);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
			var _local_3:Int;
            var _local_2= k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._recipes.push(new CraftingResultObjectParser(k));
                _local_3++;
            }
            _local_2 = k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._ingredients.push(k.readString());
                _local_3++;
            }
            return true;
        }

        public var recipes(get,never):Vector<CraftingResultObjectParser>;
function  get_recipes():Vector<CraftingResultObjectParser>
        {
            return this._recipes;
        }

        public var ingredients(get,never):Vector<String>;
function  get_ingredients():Vector<String>
        {
            return this._ingredients;
        }

        public function isActive():Bool
        {
            return (this._recipes.length > 0) || (this._ingredients.length > 0);
        }
    }

