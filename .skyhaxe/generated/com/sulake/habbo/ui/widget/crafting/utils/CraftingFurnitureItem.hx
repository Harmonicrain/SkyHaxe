package com.sulake.habbo.ui.widget.crafting.utils
;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.session.furniture.IFurnitureData;

     class CraftingFurnitureItem extends EventDispatcher 
    {
        var _productCode:String;
        var _furnitureData:IFurnitureData;
        var _inventoryIds:Vector<Int>;
        var _mixerIds:Vector<Int>;

        public function new(k:String, _arg_2:IFurnitureData)
        {
            super();
            this._productCode = k;
            this._furnitureData = _arg_2;
            this._inventoryIds = new Vector<Int>(0);
            this._mixerIds = new Vector<Int>(0);
        }

        public var furnitureData(get,never):IFurnitureData;
public function  get_furnitureData():IFurnitureData
        {
            return this._furnitureData;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return (this._furnitureData != null) ? this._furnitureData.id : -1;
        }

        public var countInInventory(get,never):Int;
public function  get_countInInventory():Int
        {
            return (this._inventoryIds != null) ? this._inventoryIds.length : 0;
        }

        public var _Str_23988(never,set):Vector<Int>;
public function  set__Str_23988(k:Vector<Int>):Vector<Int>        {
            return this._inventoryIds = k;
        }

        public function getItemToMixer():Int
        {
            if (this.countInInventory == 0)
            {
                return 0;
            }
            var k= this._inventoryIds.shift();
            this._mixerIds.push(k);
            return k;
        }

        public function returnItemToInventory(k:Int)
        {
            this._inventoryIds.push(k);
            this._mixerIds.splice(this._mixerIds.indexOf(k), 1);
        }
    }

