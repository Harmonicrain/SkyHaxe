package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog.viewer._Str_4311;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.habbo.catalog.viewer.ProductContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import com.sulake.habbo.catalog.viewer.IGridItem;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetUpdateRoomPreviewEvent;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;

     class SpacesNewCatalogWidget extends ItemGridCatalogWidget implements IDisposable implements  _Str_4311 
    {
        var _groupNames:Array<ASAny>;
        var _groups:Array<ASAny>;
        var _selectedGroup:Int = 0;
        var _groupIndex:Array<ASAny>;
        var _tabs:ISelectorWindow;
        var _categories:Array<ASAny>;

        public function new(k:IWindowContainer, _arg_2:ISessionDataManager, _arg_3:String)
        {
            this._groupNames = ["wallpaper", "floor", "landscape"];
            this._groups = new Array<ASAny>();
            this._groupIndex = [0, 0, 0];
            this._categories = ["group.walls", "group.floors", "group.views"];
            super(k, _arg_2, _arg_3);
        }

        override public function dispose()
        {
            var k:Vector<IPurchasableOffer> = null;
            var _local_2:IPurchasableOffer = null;
            super.dispose();
            final _iter_ = this._groups; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_2  = _tmp_;
                    _local_2.dispose();
                }
            }
            this._groups = null;
        }

        override public function init():Bool
        {
            var k = 0;
            var _local_2:IWindow = null;
            Logger.log(["Init Item Group Catalog Widget (Spaces New)"]);
            this._Str_24932();
            if (!super.init())
            {
                return false;
            }
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            this._tabs = Std.downcast(_window.findChildByName("groups") , ISelectorWindow);
            if (this._tabs != null)
            {
                k = 0;
                while ((k : UInt) < this._tabs.numSelectables)
                {
                    _local_2 = this._tabs.getSelectableAt(k);
                    if (Std.is(_local_2 , ISelectableWindow))
                    {
                        _local_2.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this._Str_18701);
                    }
                    k++;
                }
            }
            this.switchCategory(this._categories[this._selectedGroup]);
            this._Str_21108();
            return true;
        }

        public function onWidgetsInitialized(k:_Str_3308)
        {
            var _local_2= ASCompat.toInt(this._groupIndex[this._selectedGroup]);
            var _local_3:IPurchasableOffer = this._groups[this._selectedGroup][_local_2];
            this.select(_local_3.gridItem, false);
        }

        public function _Str_25508(k:Int)
        {
            var _local_2:IPurchasableOffer = null;
            if (((k > -1) && ((k : UInt) < _itemGrid.numGridItems)))
            {
                _local_2 = this._groups[this._selectedGroup][k];
                this.select(_local_2.gridItem, false);
            }
        }

        override public function select(k:IGridItem, _arg_2:Bool)
        {
            if (k == null)
            {
                return;
            }
            super.select(k, false);
            var _local_3= Std.downcast(k , ProductContainer).offer;
            if (_local_3 == null)
            {
                return;
            }
            events.dispatchEvent(new SetExtraPurchaseParameterEvent(_local_3.product.extraParam));
            this._groupIndex[this._selectedGroup] = ASCompat.asVector(this._groups[this._selectedGroup] , (_ : IPurchasableOffer)).indexOf(_local_3);
            this._Str_21108();
        }

        function _Str_21108()
        {
            var k= ASCompat.toInt(this._groupIndex[0]);
            var _local_2= ASCompat.toInt(this._groupIndex[1]);
            var _local_3= ASCompat.toInt(this._groupIndex[2]);
            var _local_4:IPurchasableOffer = ((this._groups[0].length > k) ? this._groups[0][k] : null);
            var _local_5:IPurchasableOffer = ((this._groups[1].length > _local_2) ? this._groups[1][_local_2] : null);
            var _local_6:IPurchasableOffer = ((this._groups[2].length > _local_3) ? this._groups[2][_local_3] : null);
            if ((((!(_local_5 != null)) || (!(_local_4 != null))) || (!(_local_6 != null))))
            {
                return;
            }
            events.dispatchEvent(new CatalogWidgetUpdateRoomPreviewEvent(_local_5.product.extraParam, _local_4.product.extraParam, _local_6.product.extraParam, 64));
        }

        function _Str_24932():Bool
        {
            var k:IPurchasableOffer = null;
            var _local_2:IProduct = null;
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5 = 0;
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (((k.pricingModel == Offer.PRICING_MODEL_SINGLE) || (k.pricingModel == Offer.PRICING_MODEL_MULTI)))
                {
                    _local_2 = k.product;
                    if (_local_2 != null)
                    {
                        _local_3 = _local_2.productClassId;
                        if (((_local_2.productType == ProductTypeEnum.WALL) || (_local_2.productType == ProductTypeEnum.FLOOR)))
                        {
                            if (_local_2.furnitureData != null)
                            {
                                _local_4 = _local_2.furnitureData.className;
                                _local_5 = this._groupNames.indexOf(_local_4);
                                if (this._groupNames.indexOf(_local_4) == -1)
                                {
                                    this._groupNames.push(_local_4);
                                }
                                while (this._groups.length < this._groupNames.length)
                                {
                                    this._groups.push(new Vector<IPurchasableOffer>(0));
                                }
                                switch (_local_4)
                                {
                                    case "floor":
                                        ASCompat.asVector(this._groups[_local_5] , (_ : IPurchasableOffer)).push(k);
                                        
                                    case "wallpaper":
                                        ASCompat.asVector(this._groups[_local_5] , (_ : IPurchasableOffer)).push(k);
                                        
                                    case "landscape":
                                        ASCompat.asVector(this._groups[_local_5] , (_ : IPurchasableOffer)).push(k);
                                        
                                    default:
                                        Logger.log([("[SpacesCatalogWidget] : " + _local_4)]);
                                }
                            }
                        }
                    }
                }
            }
            page.replaceOffers(new Vector<IPurchasableOffer>(0), false);
            return true;
        }

        function _Str_18701(k:WindowEvent)
        {
            var _local_3 = 0;
            var _local_2= Std.downcast(k.target , ISelectableWindow);
            if (_local_2 != null)
            {
                _local_3 = this._tabs.getSelectableIndex(_local_2);
                Logger.log([("select: " + ASCompat.toString([_local_2.name, _local_3]))]);
                this.switchCategory(_local_2.name);
            }
        }

        function switchCategory(k:String)
        {
            var _local_3:Vector<IPurchasableOffer> = null;
            var _local_4 = 0;
            if (disposed)
            {
                return;
            }
            if (this._tabs == null)
            {
                return;
            }
            this._tabs.setSelected(this._tabs.getSelectableByName(k));
            var _local_2= -1;
            switch (k)
            {
                case "group.walls":
                    _local_2 = 0;
                    
                case "group.floors":
                    _local_2 = 1;
                    
                case "group.views":
                    _local_2 = 2;
                    
                default:
                    _local_2 = -1;
            }
            if (_local_2 > -1)
            {
                if (_Str_2537 != null)
                {
                    _Str_2537.deactivate();
                }
                _Str_2537 = null;
                this._selectedGroup = _local_2;
                if (_itemGrid != null)
                {
                    _itemGrid.destroyGridItems();
                }
                _local_3 = ((this._groups[this._selectedGroup] == null) ? new Vector<IPurchasableOffer>(0) : this._groups[this._selectedGroup]);
                page.replaceOffers(_local_3, false);
                _Str_16173();
                _Str_6159();
                _Str_10532();
                if (_timer != null)
                {
                    _timer.start();
                }
                _local_4 = ASCompat.toInt(this._groupIndex[this._selectedGroup]);
                this._Str_25508(_local_4);
            }
        }
    }

