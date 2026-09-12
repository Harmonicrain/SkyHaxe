package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.viewer._Str_4311;
    import com.sulake.habbo.catalog.viewer.IDragAndDropDoneReceiver;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.catalog.viewer.IGridItem;
    import flash.utils.Timer;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.TimerEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.habbo.catalog.viewer.ProductContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetColoursEvent;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetInitPurchaseEvent;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog.viewer.BundleProductContainer;
    import com.sulake.habbo.catalog.viewer.IProductContainer;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetGuildSelectedEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetColourIndexEvent;

     class ItemGridCatalogWidget extends CatalogWidget implements _Str_4311 implements  IDragAndDropDoneReceiver
    {
        var _itemGrid:IItemGridWindow;
        var _Str_3370:com.sulake.core.utils.xml.XML;
        var _Str_16251:com.sulake.core.utils.xml.XML;
        var _Str_18737:com.sulake.core.utils.xml.XML;
        var _Str_2537:IGridItem;
        var _Str_18734:Int = 0;
        var _timer:Timer;
        var _Str_23853:Bool = true;
        var _Str_8035:Int = 0;
        var _Str_2720:ISessionDataManager;
        var _Str_18623:Int = -1;
        var _selectedGuildColor1:String;
        var _selectedGuildColor2:String;
        var _Str_19595:String;
        var _Str_2796:String;
        public var _Str_8284:ASDictionary<ASAny,ASAny>;
        public var _Str_26046:Int = 0;
        var _Str_26230:Int = 0;

        public function new(k:IWindowContainer, _arg_2:ISessionDataManager, _arg_3:String)
        {
            this._Str_8284 = new ASDictionary<ASAny,ASAny>();
            super(k);
            this._Str_2720 = _arg_2;
            this._Str_2796 = _arg_3;
        }

        override public function dispose()
        {
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, (this._Str_10532 : ASAny));
                this._timer = null;
            }
            if (this._itemGrid != null)
            {
                this._itemGrid.destroyGridItems();
                this._itemGrid = null;
            }
            this._Str_3370 = null;
            this._Str_16251 = null;
            this._Str_18737 = null;
            this._Str_2537 = null;
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.ITEM_GRID);
            var k:ASAny = (_window.tags.indexOf("FIXED") > -1);
            this._itemGrid = Std.downcast(_window.findChildByName("itemGrid") , IItemGridWindow);
            if (!k)
            {
                _window.getChildAt(0).width = _window.width;
                _window.getChildAt(0).height = _window.height;
            }
            this._itemGrid.verticalSpacing = 0;
            var _local_2= Std.downcast(page.viewer.catalog.assets.getAssetByName("gridItem") , XmlAsset);
            this._Str_3370 = ((_local_2.content : com.sulake.core.utils.xml.XML) );
            _local_2 = Std.downcast(page.viewer.catalog.assets.getAssetByName("grid_item_with_price_single") , XmlAsset);
            this._Str_18737 = ((_local_2.content : com.sulake.core.utils.xml.XML) );
            _local_2 = Std.downcast(page.viewer.catalog.assets.getAssetByName("grid_item_with_price_multi") , XmlAsset);
            this._Str_16251 = ((_local_2.content : com.sulake.core.utils.xml.XML) );
            this._Str_6159();
            if (this._Str_23853)
            {
                this._timer = new Timer(25);
                this._timer.addEventListener(TimerEvent.TIMER, (this._Str_10532 : ASAny));
                this._timer.start();
            }
            else
            {
                this._Str_10532();
            }
            events.addEventListener(CatalogWidgetEvent.GUILD_SELECTED, this._Str_16625);
            events.addEventListener(CatalogWidgetEvent.COLOUR_INDEX, this._Str_7756);
            return true;
        }

        public function select(k:IGridItem, _arg_2:Bool)
        {
            if (this._Str_2537 != null)
            {
                this._Str_2537.deactivate();
            }
            this._Str_2537 = k;
            k.activate();
            if (this._Str_2537.view != null)
            {
                this._Str_2537.view.findChildByName("border_outline").color = ((this._Str_2796 == CatalogType.NORMAL) ? 6538729 : 16758076);
            }
            var _local_3= Std.downcast(k , ProductContainer);
            if (_local_3 == null)
            {
                return;
            }
            if (_local_3.isLazy)
            {
                return;
            }
            var _local_4= _local_3.offer;
            if (_local_4 != null)
            {
                events.dispatchEvent(new SelectProductEvent(_local_4));
                if (((_local_4.product != null) && (_local_4.product.productType == ProductTypeEnum.WALL)))
                {
                    events.dispatchEvent(new SetExtraPurchaseParameterEvent(_local_4.product.extraParam));
                }
            }
            if (_arg_2)
            {
                events.dispatchEvent(new CatalogWidgetColoursEvent(this._Str_23323(), "ctlg_clr_27x22_1", "ctlg_clr_27x22_2", "ctlg_clr_27x22_3", this._Str_25049()));
            }
        }

        public function _Str_9974(k:IGridItem):Bool
        {
            var _local_2= Std.downcast(k , ProductContainer).offer;
            if (_local_2 != null)
            {
                if (this._Str_2720.clubLevel >= _local_2.clubLevel)
                {
                    Std.downcast(page.viewer.catalog , HabboCatalog).requestSelectedItemToMover(this, _local_2);
                }
            }
            return true;
        }

        public function onDragAndDropDone(k:Bool, _arg_2:String)
        {
            if (disposed)
            {
                return;
            }
            if (k)
            {
                events.dispatchEvent(new CatalogWidgetInitPurchaseEvent(false, _arg_2));
            }
        }

        public function _Str_22911()
        {
        }

        function _Str_6159()
        {
            var _local_3:String = null;
            var _local_4 = 0;
            var _local_5:IPurchasableOffer = null;
            var _local_6:UInt = 0;
            var _local_7:UInt = 0;
            var k:Array<ASAny> = [];
            var _local_2= new Vector<IPurchasableOffer>();
            if (page.layoutCode == "default_3x3_color_grouping")
            {
                ASCompat.ASVector.sort(page.offers, this._Str_24008);
                final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    if (((!(_local_5.product.furnitureData != null)) || (!_local_5.product.isColorable)))
                    {
                        _local_2.push(_local_5);
                    }
                    else
                    {
                        _local_3 = _local_5.product.furnitureData.fullName.split("*")[0];
                        _local_4 = ASCompat.toInt(_local_5.product.furnitureData.fullName.split("*")[1]);
                        if (!this._Str_8284[_local_3])
                        {
                            this._Str_8284[_local_3] = ([] : Array<Dynamic>);
                        }
                        if (_local_5.product.furnitureData.colours != null)
                        {
                            final _iter_ = _local_5.product.furnitureData.colours; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_6  = ASCompat.toUInt(_tmp_);
                                if (_local_6 != 0xFFFFFF)
                                {
                                    _local_7 = _local_6;
                                }
                            }
                            if (this._Str_8284[_local_3].indexOf(_local_7) == -1)
                            {
                                this._Str_8284[_local_3][_local_4] = _local_7;
                            }
                        }
                        if (k.indexOf(_local_3) == -1)
                        {
                            _local_2.push(_local_5);
                            k.push(_local_3);
                        }
                    }
                }
                ASCompat.ASVector.sort(page.offers, this._Str_24106);
            }
            else
            {
                _local_2 = page.offers;
            }
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                this._Str_7360(_local_5.gridItem, (!(_local_2.indexOf(_local_5) == -1)));
                _local_5.gridItem.grid = this;
                if (_local_5.pricingModel == Offer.PRICING_MODEL_BUNDLE)
                {
                    this._Str_18734++;
                    if (Std.is(_local_5.productContainer , BundleProductContainer))
                    {
                        Std.downcast(_local_5.productContainer , BundleProductContainer)._Str_21877(this._Str_18734);
                    }
                }
            }
        }

        function _Str_24008(k:IPurchasableOffer, _arg_2:IPurchasableOffer):Int
        {
            if (((!(k.product.furnitureData.colourIndex != 0)) || (!(_arg_2.product.furnitureData.colourIndex != 0))))
            {
                return 1;
            }
            if (k.product.furnitureData.colourIndex > _arg_2.product.furnitureData.colourIndex)
            {
                return 1;
            }
            if (k == _arg_2)
            {
                return 0;
            }
            return -1;
        }

        function _Str_24106(k:IPurchasableOffer, _arg_2:IPurchasableOffer):Int
        {
            if (k.product.furnitureData.className > _arg_2.product.furnitureData.className)
            {
                return 1;
            }
            if (k == _arg_2)
            {
                return 0;
            }
            return -1;
        }

        function _Str_16173()
        {
            if (this._timer != null)
            {
                this._timer.reset();
            }
            this._Str_8035 = 0;
        }

        function _Str_10532(k:TimerEvent=null)
        {
            var _local_3 = 0;
            var _local_4:IPurchasableOffer = null;
            if (disposed)
            {
                return;
            }
            if (k != null)
            {
            }
            var _local_2= page.offers.length;
            if (_local_2 > 0)
            {
                _local_3 = 0;
                while (_local_3 < 3)
                {
                    if (((this._Str_8035 >= 0) && (this._Str_8035 < _local_2)))
                    {
                        _local_4 = page.offers[this._Str_8035];
                        this._Str_19318(_local_4);
                        _local_4.productContainer.grid = this;
                    }
                    this._Str_8035++;
                    if (this._Str_8035 >= _local_2)
                    {
                        this._Str_16173();
                        return;
                    }
                    _local_3++;
                }
            }
        }

        function _Str_7360(k:IGridItem, _arg_2:Bool=true)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4= ASCompat.reinterpretAs(k , IProductContainer);
            var _local_5= (((!(_local_4 == null)) && (!(_local_4.offer == null))) && ((_local_4.offer.priceInCredits > 0) || (_local_4.offer.priceInActivityPoints > 0)));
            if ((_local_5 && (!(this._Str_2796 == CatalogType.BUILDER))))
            {
                if ((((_local_4.offer != null) && (_local_4.offer.priceInCredits > 0)) && (_local_4.offer.priceInActivityPoints > 0)))
                {
                    _local_3 = this._Str_16251;
                }
                else
                {
                    _local_3 = this._Str_18737;
                }
            }
            else
            {
                _local_3 = this._Str_3370;
            }
            var _local_6= Std.downcast(page.viewer.catalog.windowManager.buildFromXML(_local_3) , IWindowContainer);
            if (_arg_2)
            {
                this._itemGrid.addGridItem(_local_6);
            }
            k.view = _local_6;
            if (Std.is(_local_4 , ProductContainer))
            {
                Std.downcast(_local_4 , ProductContainer)._Str_18628(Std.downcast(page.viewer.catalog , HabboCatalog));
            }
        }

        function _Str_19318(k:IPurchasableOffer)
        {
            var _local_2:IStuffData = null;
            var _local_3:Array<ASAny> = null;
            var _local_4:StringArrayStuffData = null;
            if (((!(k == null)) && (!k.disposed)))
            {
                _local_2 = null;
                if (this._Str_18623 != CatalogWidgetGuildSelectedEvent._Str_15457)
                {
                    _local_3 = new Array<ASAny>();
                    _local_3.push("0");
                    _local_3.push(Std.string(this._Str_18623));
                    _local_3.push(this._Str_19595);
                    _local_3.push(this._selectedGuildColor1);
                    _local_3.push(this._selectedGuildColor2);
                    _local_4 = new StringArrayStuffData();
                    _local_4._Str_13438(_local_3);
                    _local_2 = _local_4;
                }
                k.productContainer.initProductIcon(page.viewer.roomEngine, _local_2);
            }
        }

        function _Str_16625(k:CatalogWidgetGuildSelectedEvent)
        {
            var _local_2:IPurchasableOffer = null;
            if (disposed)
            {
                return;
            }
            this._Str_18623 = k.guildId;
            this._selectedGuildColor1 = k.color1;
            this._selectedGuildColor2 = k.color2;
            this._Str_19595 = k.badgeCode;
            this._itemGrid.destroyGridItems();
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._Str_7360(_local_2.gridItem);
                this._Str_19318(_local_2);
                _local_2.productContainer.grid = this;
            }
        }

        function _Str_25239(k:IPurchasableOffer)
        {
            if (this._itemGrid.getGridItemIndex(k.gridItem.view) >= 0)
            {
                this._itemGrid.removeGridItem(k.gridItem.view);
            }
        }

        function _Str_7756(k:CatalogWidgetColourIndexEvent)
        {
            var _local_2:IPurchasableOffer = null;
            var _local_3:IPurchasableOffer = null;
            var _local_4 = 0;
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.gridItem == this._Str_2537)
                {
                    _local_2 = _local_3;
                }
            }
            if (((!(_local_2 != null)) || (!_local_2.product.isColorable)))
            {
                return;
            }
            _local_4 = this._itemGrid.getGridItemIndex(_local_2.gridItem.view);
            this._Str_25239(_local_2);
            var _local_5= ((_local_2.product.furnitureData.fullName.split("*")[0] + "*") + Std.string(k.index + 1));
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.product.furnitureData.fullName == _local_5)
                {
                    this._itemGrid.addGridItemAt(_local_3.gridItem.view, _local_4);
                    this.select(_local_3.gridItem, false);
                    _local_3.gridItem.grid = this;
                }
            }
        }

        public function _Str_23323():Array<ASAny>
        {
            var k:IPurchasableOffer = null;
            var _local_2:IPurchasableOffer = null;
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gridItem == this._Str_2537)
                {
                    k = _local_2;
                }
            }
            if (((!(k != null)) || (!k.product.isColorable)))
            {
                return [];
            }
            return this._Str_8284[k.product.furnitureData.fullName.split("*")[0]];
        }

        function _Str_25049():Int
        {
            var k:IPurchasableOffer = null;
            var _local_2:IPurchasableOffer = null;
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.gridItem == this._Str_2537)
                {
                    k = _local_2;
                }
            }
            if (((!(k != null)) || (!k.product.isColorable)))
            {
                return 0;
            }
            return Std.int(Math.max((k.product.furnitureData.colourIndex - 1), 0));
        }
    }

