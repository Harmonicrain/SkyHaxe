package com.sulake.habbo.ui.widget.crafting.renderer
;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;

     class CraftingInventoryItemRenderer extends FurniThumbnailRendererBase 
    {
        public function new(k:CraftingFurnitureItem, _arg_2:IWindowContainer, _arg_3:CraftingWidget)
        {
            super(k, _arg_2, _arg_3);
            _Str_22233();
        }

        override function onTriggered()
        {
            if ((((!(_widget != null)) || (!(content != null))) || _widget.craftingInProgress))
            {
                return;
            }
            _widget.showCraftableProduct(content);
        }
    }

