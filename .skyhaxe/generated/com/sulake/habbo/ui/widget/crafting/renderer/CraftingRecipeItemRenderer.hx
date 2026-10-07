package com.sulake.habbo.ui.widget.crafting.renderer
;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;

     class CraftingRecipeItemRenderer extends FurniThumbnailRendererBase 
    {
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
            if (!_widget.mixerCtrl.canAdd())
            {
                return;
            }
            var k= content.getItemToMixer();
            if (k == 0)
            {
                return;
            }
            _widget.showSecretRecipeView();
            _widget.mixerCtrl.addItemToMixer(content, k);
            _widget.inventoryCtrl.updateItemCounts();
        }

        override public function updateItemCount()
        {
            if (content != null)
            {
                _Str_21081(content.countInInventory);
                _Str_14878((content.countInInventory > 0));
            }
        }
    }

