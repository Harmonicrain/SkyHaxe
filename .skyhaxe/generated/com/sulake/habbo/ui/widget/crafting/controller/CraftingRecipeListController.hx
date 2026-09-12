package com.sulake.habbo.ui.widget.crafting.controller
;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.habbo.ui.widget.crafting.renderer.CraftingInventoryItemRenderer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftinRecipeIngredientParser;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingViewStateEnum;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.core.window.components.IItemGridWindow;

     class CraftingRecipeListController extends CraftingGridControllerBase 
    {
        var _craftableProduct:CraftingFurnitureItem;
        var _items:Vector<CraftingInventoryItemRenderer>;

        public function new(k:CraftingWidget)
        {
            super(k);
            this._items = new Vector<CraftingInventoryItemRenderer>(0);
        }

        override public function dispose()
        {
            this.clearItems();
            this._craftableProduct = null;
            super.dispose();
        }

        public function clearItems()
        {
            var k:CraftingInventoryItemRenderer = null;
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

        public function _Str_17264(k:Vector<CraftingFurnitureItem>)
        {
            var _local_4:CraftingInventoryItemRenderer = null;
            if (this.container == null)
            {
                return;
            }
            var _local_2= getItemTemplate();
            this.container.removeGridItems();
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_4 = new CraftingInventoryItemRenderer(k[_local_3], Std.downcast(_local_2.clone() , IWindowContainer), _widget);
                this.container.addGridItem(_local_4.window);
                this._items.push(_local_4);
                _local_3++;
            }
        }

        public function _Str_24714(k:CraftingFurnitureItem, _arg_2:Vector<CraftinRecipeIngredientParser>)
        {
            var _local_5 = 0;
            var _local_6:CraftinRecipeIngredientParser = null;
            var _local_7:IFurnitureData = null;
            var _local_8:Array<ASAny> = null;
            var _local_9 = 0;
            var _local_10:CraftingFurnitureItem = null;
            this._craftableProduct = k;
            if (_arg_2 == null)
            {
                _widget.setInfoState(CraftingViewStateEnum._Str_9812);
                return;
            }
            _widget.mixerCtrl.clearItems();
            var _local_3= true;
            var _local_4= new Vector<String>(0);
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_6  = _tmp_;
                _local_7 = _widget.sessionDataManager.getFloorItemDataByName(_local_6.itemName);
                if (_local_7 == null)
                {
                    return;
                }
                _local_8 = _widget.handler.container.inventory.getNonRentedInventoryIds(InventoryCategory.FURNI, _local_7.id);
                if (((_local_8 == null) || (_local_8.length < _local_6.count)))
                {
                    _local_3 = false;
                }
                _local_9 = 0;
                while (_local_9 < _local_6.count)
                {
                    _local_10 = new CraftingFurnitureItem(null, _local_7);
                    if (((_local_8 != null) && (_local_8.length != 0)))
                    {
                        _local_5 = ASCompat.toInt(_local_8.shift());
                    }
                    else
                    {
                        _local_5 = 0;
                        if (_local_4.indexOf(_local_7.localizedName) == -1)
                        {
                            _local_4.push(_local_7.localizedName);
                        }
                    }
                    _widget.mixerCtrl.addItemToMixer(_local_10, _local_5);
                    _local_9++;
                }
            }
            if (_local_3)
            {
                _widget.setInfoState(CraftingViewStateEnum._Str_15345, [this._craftableProduct.furnitureData]);
            }
            else
            {
                _widget.setInfoState(CraftingViewStateEnum._Str_9812, [this._craftableProduct.furnitureData, _local_4]);
            }
        }

        var container(get,never):IItemGridWindow;
function  get_container():IItemGridWindow
        {
            return (mainWindow != null) ? Std.downcast(mainWindow.findChildByName("itemgrid_products") , IItemGridWindow) : null;
        }
    }

