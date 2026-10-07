package com.sulake.habbo.ui.widget.crafting.renderer
;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingViewStateEnum;

     class CraftingMixerItemRenderer extends FurniThumbnailRendererBase 
    {
        var _inventoryId:Int = 0;

        public function new(k:CraftingFurnitureItem, _arg_2:IWindowContainer, _arg_3:CraftingWidget)
        {
            super(k, _arg_2, _arg_3);
        }

        override function onTriggered()
        {
            if ((((!(_widget != null)) || _widget.craftingInProgress) || _widget.inventoryDirty))
            {
                return;
            }
            if (this._inventoryId == 0)
            {
                _widget.setInfoState(CraftingViewStateEnum._Str_15827, [furnitureData]);
                return;
            }
            if (_widget.inSecretRecipeMode)
            {
                _widget.mixerCtrl.removeListItem(this);
            }
        }

        public function returnItemToInventory()
        {
            if (this._inventoryId != 0)
            {
                _data.returnItemToInventory(this._inventoryId);
            }
            this.dispose();
        }

        override public function updateItemCount()
        {
            _Str_14878((!(this._inventoryId == 0)));
        }

        
        public var _Str_18598(get,set):Int;
public function  get__Str_18598():Int
        {
            return this._inventoryId;
        }
public function  set__Str_18598(k:Int):Int        {
            this._inventoryId = k;
            this.updateItemCount();
return k;
        }
    }

