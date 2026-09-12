package com.sulake.habbo.ui.widget.crafting.controller
;
    import com.sulake.habbo.ui.widget.crafting.renderer.CraftingMixerItemRenderer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.ui.widget.crafting.*;

     class CraftingMixerController extends CraftingGridControllerBase 
    {
        static inline final _Str_17735= 10;

        var _renderers:Vector<CraftingMixerItemRenderer>;

        public function new(k:CraftingWidget)
        {
            super(k);
            this._renderers = new Vector<CraftingMixerItemRenderer>(0);
        }

        override public function dispose()
        {
            this._Str_21521();
            super.dispose();
        }

        public function _Str_21521()
        {
            var _local_2:CraftingMixerItemRenderer = null;
            var k = 0;
            while (k < this._renderers.length)
            {
                _local_2 = this._renderers[k];
                if (_local_2 != null)
                {
                    _local_2.returnItemToInventory();
                }
                k++;
            }
            this._renderers.length = 0;
            if (this.container != null)
            {
                this.container.destroyGridItems();
            }
            if (((_widget != null) && (_widget.inventoryCtrl != null)))
            {
                _widget.inventoryCtrl.updateItemCounts();
            }
        }

        public function clearItems()
        {
            this._Str_21521();
            if (this.container != null)
            {
                this.container.destroyGridItems();
            }
        }

        public function canAdd():Bool
        {
            return this._renderers.length < _Str_17735;
        }

        public function addItemToMixer(k:CraftingFurnitureItem, _arg_2:Int):Bool
        {
            if (this.container == null)
            {
                return false;
            }
            var _local_3= getItemTemplate();
            var _local_4= new CraftingMixerItemRenderer(k, Std.downcast(_local_3.clone() , IWindowContainer), _widget);
            _local_4._Str_18598 = _arg_2;
            this.container.addGridItem(_local_4.window);
            this._renderers.push(_local_4);
            if (_widget.inSecretRecipeMode)
            {
                _widget.mixerContentChanged(this._Str_16929());
            }
            return true;
        }

        public function removeListItem(k:CraftingMixerItemRenderer)
        {
            var _local_3:CraftingMixerItemRenderer = null;
            if (this.container == null)
            {
                return;
            }
            var _local_2 = 0;
            while (_local_2 < this._renderers.length)
            {
                _local_3 = this._renderers[_local_2];
                if (_local_3 == k)
                {
                    this._renderers.splice(_local_2, 1);
                    if (_local_3.window != null)
                    {
                        this.container.removeGridItem(_local_3.window);
                        this.container.rebuildGridStructure();
                    }
                    _local_3.returnItemToInventory();
                    _widget.inventoryCtrl.updateItemCounts();
                    _widget.mixerContentChanged(this._Str_16929());
                    return;
                }
                _local_2++;
            }
        }

        public function _Str_16929():Vector<Int>
        {
            var _local_3:CraftingMixerItemRenderer = null;
            var k= new Vector<Int>(0);
            var _local_2 = 0;
            while (_local_2 < this._renderers.length)
            {
                _local_3 = this._renderers[_local_2];
                if (_local_3 != null)
                {
                    k.push(_local_3._Str_18598);
                }
                _local_2++;
            }
            return k;
        }

        var container(get,never):IItemGridWindow;
function  get_container():IItemGridWindow
        {
            return (mainWindow != null) ? Std.downcast(mainWindow.findChildByName("itemgrid_mixer") , IItemGridWindow) : null;
        }
    }

