package com.sulake.habbo.catalog
;
    import com.sulake.habbo.catalog.navigation.CatalogNavigator;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.habbo.catalog.navigation.ICatalogNode;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class TopViewSelector 
    {
        var _catalog:CatalogNavigator;
        var _template:ITabButtonWindow;
        var _tabContext:ITabContextWindow;

        public function new(k:CatalogNavigator, _arg_2:ITabContextWindow)
        {
            this._catalog = k;
            this._tabContext = _arg_2;
            var _local_3= cast(_arg_2.getTabButtonAt(0).clone(), ITabButtonWindow);
            this._template = _local_3;
            this._tabContext._Str_5897(_local_3);
        }

        public function _Str_5377(k:ICatalogNode)
        {
            var _local_2= cast(this._template.clone(), ITabButtonWindow);
            _local_2.caption = k.localization;
            _local_2.name = k.pageName;
            _local_2.procedure = this._Str_18312;
            this._tabContext._Str_5377(_local_2);
            this._Str_23691();
        }

        function _Str_23691()
        {
            var k = 0;
            while ((k : UInt) < this._tabContext.numTabs)
            {
                this._tabContext.getTabButtonAt(k).width = Std.int(this._tabContext.getTabButtonAt(k).parent.width / this._tabContext.numTabs);
                k++;
            }
        }

        public function _Str_17441()
        {
            while (this._tabContext.numTabs > 0)
            {
                this._tabContext._Str_5897(this._tabContext.getTabButtonAt(0));
            }
        }

        public function _Str_12925(k:Int)
        {
            this._tabContext.selector.setSelected(this._tabContext.getTabButtonAt(k));
            this._Str_21480(this._tabContext.getTabButtonAt(k));
        }

        function _Str_18312(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ITabButtonWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = Std.downcast(_arg_2 , ITabButtonWindow);
                if (_local_3 != null)
                {
                    this._Str_21480(_local_3);
                }
            }
        }

        function _Str_21480(k:ITabButtonWindow)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= this._catalog.getNodeByName(k.name);
            if (_local_2 != null)
            {
                this._catalog._Str_20996(_local_2);
            }
        }
    }


