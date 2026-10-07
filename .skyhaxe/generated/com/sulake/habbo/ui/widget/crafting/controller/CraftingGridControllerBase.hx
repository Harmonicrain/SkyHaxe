package com.sulake.habbo.ui.widget.crafting.controller
;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.core.window.IWindowContainer;

     class CraftingGridControllerBase 
    {
        var _widget:CraftingWidget;

        public function new(k:CraftingWidget)
        {
            this._widget = k;
        }

        public function dispose()
        {
            this._widget = null;
        }

        public var mainWindow(get,never):IWindowContainer;
public function  get_mainWindow():IWindowContainer
        {
            return this._widget.window;
        }

        public function getItemTemplate():IWindowContainer
        {
            return this._widget._Str_24863;
        }
    }

