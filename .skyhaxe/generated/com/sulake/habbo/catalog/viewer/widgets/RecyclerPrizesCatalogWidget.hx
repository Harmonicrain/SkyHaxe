package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.viewer._Str_4311;
    import com.sulake.habbo.catalog.recycler.PrizeViewer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.catalog.viewer.IGridItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.recycler._Str_3903;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.catalog.recycler.PrizeLevelContainer;
    import com.sulake.habbo.catalog.recycler.DealPrizeContainer;
    import com.sulake.habbo.catalog.recycler.IRecycler;

     class RecyclerPrizesCatalogWidget extends CatalogWidget implements _Str_4311 
    {
        var _Str_3154:Array<ASAny>;
        var _Str_4944:PrizeViewer;
        var _itemList:IItemListWindow;
        var _Str_3370:com.sulake.core.utils.xml.XML;
        var _Str_16116:com.sulake.core.utils.xml.XML;
        var _Str_2537:IGridItem;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            super.dispose();
            if (this._Str_4944 != null)
            {
                this._Str_4944.dispose();
                this._Str_4944 = null;
            }
            this._Str_3154 = null;
            this._itemList = null;
            this._Str_3370 = null;
            this._Str_16116 = null;
            this._Str_2537 = null;
        }

        override public function init():Bool
        {
            var k:XmlAsset = null;
            if (!super.init())
            {
                return false;
            }
            this._Str_4944 = new PrizeViewer();
            this._Str_3154 = this.recycler.getPrizeTable();
            if (this._Str_3154 == null)
            {
                return false;
            }
            this._itemList = Std.downcast(_window.findChildByName("itemList") , IItemListWindow);
            k = Std.downcast(page.viewer.catalog.assets.getAssetByName("gridItem") , XmlAsset);
            this._Str_3370 = ((k.content : com.sulake.core.utils.xml.XML) );
            k = Std.downcast(page.viewer.catalog.assets.getAssetByName("recyclerPrizesWidgetLevelItem") , XmlAsset);
            this._Str_16116 = ((k.content : com.sulake.core.utils.xml.XML) );
            this._Str_6159();
            if (((this._Str_3154.length > 0) && (this._Str_3154[0].prizes.length > 0)))
            {
                this.select(ASCompat.dynamicAs(this._Str_3154[0].prizes[0] , IGridItem), false);
            }
            return true;
        }

        function _Str_6159(k:TimerEvent=null)
        {
            var _local_2 = 0;
            while (_local_2 < this._Str_3154.length)
            {
                this._Str_24166(this._Str_3154[_local_2]);
                _local_2++;
            }
        }

        function _Str_24166(k:PrizeLevelContainer)
        {
            var _local_6:_Str_3903 = null;
            var _local_2= Std.downcast(page.viewer.catalog.windowManager.buildFromXML(this._Str_16116) , IWindowContainer);
            this._itemList.addListItem(_local_2);
            var _local_3= _local_2.findChildByName("headerText");
            if (_local_3 != null)
            {
                _local_3.caption = page.viewer.catalog.localization.getLocalization(("recycler.prizes.category." + Std.string(k._Str_16418)));
            }
            var _local_4= Std.downcast(_local_2.findChildByName("itemGrid") , IItemGridWindow);
            var _local_5 = 0;
            while (_local_5 < k.prizes.length)
            {
                _local_6 = k.prizes[_local_5];
                this._Str_26473(_local_6, _local_4);
                _local_5++;
            }
        }

        function _Str_26473(k:_Str_3903, _arg_2:IItemGridWindow)
        {
            if ((((k == null) || (_arg_2 == null)) || _arg_2.disposed))
            {
                return;
            }
            var _local_3= Std.downcast(page.viewer.catalog.windowManager.buildFromXML(this._Str_3370) , IWindowContainer);
            _local_3.findChildByName("clubLevelIcon").visible = false;
            k.view = _local_3;
            k.grid = this;
            k.setIcon(page.viewer.roomEngine);
            _arg_2.addGridItem(_local_3);
            _arg_2.height = Std.int(_arg_2.scrollableRegion.height);
            if (Std.is(k , DealPrizeContainer))
            {
                _arg_2.width = Std.int(_arg_2.scrollableRegion.width);
            }
        }

        public function select(k:IGridItem, _arg_2:Bool)
        {
            if (k == null)
            {
                return;
            }
            if (this._Str_2537 != null)
            {
                this._Str_2537.deactivate();
            }
            this._Str_2537 = k;
            k.activate();
            var _local_3= Std.downcast(window.findChildByName("productView") , IWindowContainer);
            var _local_4= Std.downcast(k , _Str_3903);
            var _local_5= Std.downcast(k , DealPrizeContainer);
            var _local_6= "";
            if (_local_5 != null)
            {
                _local_6 = page.viewer.catalog.localization.getLocalization(("recycler.prizes.odds." + Std.string(_local_4._Str_21913)));
                this._Str_4944._Str_22540(page.viewer.roomEngine, page, this._Str_3370, _local_3, _local_5, _local_4.title, _local_6);
            }
            else
            {
                if (_local_4 != null)
                {
                    _local_6 = page.viewer.catalog.localization.getLocalization(("recycler.prizes.odds." + Std.string(_local_4._Str_21913)));
                    this._Str_4944._Str_25618(page.viewer.roomEngine, _local_3, _local_4._Str_7585, _local_4._Str_6270, _local_4.title, _local_6);
                }
            }
        }

        public function _Str_9974(k:IGridItem):Bool
        {
            return false;
        }

        var recycler(get,never):IRecycler;
function  get_recycler():IRecycler
        {
            return page.viewer.catalog.getRecycler();
        }
    }

