package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.catalog.navigation.CatalogNavigator;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import flash.events.Event;
    import com.sulake.habbo.session.furniture.IFurnitureData;

     class CatalogViewer implements ICatalogViewer 
    {
        var _catalog:HabboCatalog;
        var _container:IWindowContainer;
        var _page:ICatalogPage;
        var _forceRefresh:Bool = false;
        var _previousPageId:Int = 0;

        public function new(k:HabboCatalog, _arg_2:IWindowContainer)
        {
            this._catalog = k;
            this._container = _arg_2;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._catalog.roomEngine;
        }

        public function dispose()
        {
            if (this._page != null)
            {
                this._page.dispose();
                this._page = null;
            }
            this._catalog = null;
            this._container = null;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public function _Str_19388(k:Int, _arg_2:String, _arg_3:IPageLocalization, _arg_4:Vector<IPurchasableOffer>, _arg_5:Int, _arg_6:Bool)
        {
            Logger.log([("[Catalog Viewer] Show Catalog Page: " + ASCompat.toString([k, _arg_2, _arg_4.length, _arg_5]))]);
            if (this._page != null)
            {
                if (((!this._forceRefresh) && (this._page.pageId == k)))
                {
                    if (_arg_5 > -1)
                    {
                        this._page.selectOffer(_arg_5);
                    }
                    return;
                }
                this._Str_23905();
            }
            var _local_7:ICatalogPage = new CatalogPage(this, k, _arg_2, _arg_3, _arg_4, this._catalog, _arg_6);
            this._page = _local_7;
            this._previousPageId = ((k > CatalogNavigator.DUMMY_PAGE_ID_FOR_OFFER_SEARCH) ? k : this._previousPageId);
            if (_local_7.window != null)
            {
                this._container.addChild(_local_7.window);
                _local_7.window.height = this._container.height;
                this._container.width = _local_7.window.width;
                this._container.x = ((this._container.parent.width - this._container.width) - 8);
                if (this._container.x < 130)
                {
                    this._catalog.setLeftPaneVisibility(false);
                }
                else
                {
                    this._catalog.setLeftPaneVisibility(true);
                }
            }
            else
            {
                Logger.log([("[CatalogViewer] No window for page: " + _arg_2)]);
            }
            this._container.visible = true;
            this._forceRefresh = false;
            _local_7.selectOffer(_arg_5);
        }

        public function _Str_23905()
        {
            if (this._page != null)
            {
                this._container.removeChild(this._page.window);
                this._page.dispose();
                this._container.invalidate();
            }
        }

        public function _Str_20980()
        {
            if (this._page != null)
            {
                this._page.closed();
            }
        }

        public function dispatchWidgetEvent(k:Event):Bool
        {
            return this._page.dispatchWidgetEvent(k);
        }

        public function getCurrentLayoutCode():String
        {
            if (this._page == null)
            {
                return "";
            }
            return this._page.layoutCode;
        }

        public var currentPage(get,never):ICatalogPage;
public function  get_currentPage():ICatalogPage
        {
            return this._page;
        }

        public function _Str_22433(k:Vector<IFurnitureData>)
        {
            var _local_3:IFurnitureData = null;
            var _local_4:ICatalogPage = null;
            var _local_5:IPurchasableOffer = null;
            if (this._page != null)
            {
                this._container.removeChild(this._page.window);
                this._page.dispose();
            }
            var _local_2= new Vector<IPurchasableOffer>(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_5 = new FurnitureOffer(_local_3, this._catalog);
                _local_2.push(_local_5);
            }
            _local_4 = new CatalogPage(this, -1, "default_3x3", new PageLocalization(["catalog_header_roombuilder", "credits_v3_teaser"], ["${catalog.search.results}"]), _local_2, this._catalog, false, CatalogPage._Str_7035);
            this._page = _local_4;
            if (_local_4.window != null)
            {
                this._container.addChild(_local_4.window);
                _local_4.window.width = this._container.width;
                _local_4.window.height = this._container.height;
            }
            else
            {
                Logger.log([("[CatalogViewer] No window for page: " + "<SEARCH>")]);
            }
            this._container.visible = true;
        }

        public var _Str_20991(get,never):Array<ASAny>;
public function  get__Str_20991():Array<ASAny>
        {
            return (this._container != null) ? this._container.tags : [];
        }

        public function _Str_21608()
        {
            this._forceRefresh = true;
        }

        public var _Str_20548(get,never):Int;
public function  get__Str_20548():Int
        {
            return this._previousPageId;
        }
    }

