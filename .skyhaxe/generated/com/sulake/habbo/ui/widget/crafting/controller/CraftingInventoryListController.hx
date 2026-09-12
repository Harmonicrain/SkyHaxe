package com.sulake.habbo.ui.widget.crafting.controller
;
    import com.sulake.habbo.ui.widget.crafting.renderer.CraftingRecipeItemRenderer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.core.window.components.IItemGridWindow;

     class CraftingInventoryListController extends CraftingGridControllerBase 
    {
        var _items:Vector<CraftingRecipeItemRenderer>;

        public function new(k:CraftingWidget)
        {
            super(k);
            this._items = new Vector<CraftingRecipeItemRenderer>(0);
        }

        override public function dispose()
        {
            this.clearItems();
            super.dispose();
        }

        public function clearItems()
        {
            var k:CraftingRecipeItemRenderer = null;
            if (this._items != null)
            {
                final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
                this._items.length = 0;
            }
            if (this.container != null)
            {
                this.container.destroyGridItems();
            }
        }

        public function _Str_18732(k:Vector<CraftingFurnitureItem>)
        {
            var _local_4:CraftingRecipeItemRenderer = null;
            if (this.container == null)
            {
                return;
            }
            var _local_2= getItemTemplate();
            this.container.removeGridItems();
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_4 = new CraftingRecipeItemRenderer(k[_local_3], Std.downcast(_local_2.clone() , IWindowContainer), _widget);
                this.container.addGridItem(_local_4.window);
                this._items.push(_local_4);
                _local_3++;
            }
        }

        public function updateItemCounts()
        {
            var k:CraftingRecipeItemRenderer = null;
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.updateItemCount();
            }
        }

        var container(get,never):IItemGridWindow;
function  get_container():IItemGridWindow
        {
            return (mainWindow != null) ? Std.downcast(mainWindow.findChildByName("itemgrid_inventory") , IItemGridWindow) : null;
        }
    }

