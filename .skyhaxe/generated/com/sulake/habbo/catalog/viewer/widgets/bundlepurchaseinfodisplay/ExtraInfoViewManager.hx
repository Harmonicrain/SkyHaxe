package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
	import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
	import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoListItem;
    import com.sulake.habbo.catalog.viewer.widgets.BundlePurchaseExtraInfoCatalogWidget;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem.ExtraInfoPromoItem;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem.ExtraInfoBundlesInfoItem;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem.ExtraInfoDiscountValueItem;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem.ExtraInfoBonusBadgeItem;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem.ExtraInfoBonusAchievementItem;
    import com.sulake.core.window.IWindow;

     class ExtraInfoViewManager implements IDisposable implements  IUpdateReceiver 
    {
        static inline final _Str_9363= 0.5;
        static inline final _Str_13502= 28;

        var _widget:BundlePurchaseExtraInfoCatalogWidget;
        var _catalog:HabboCatalog;
        var _items:Map;
        var _idGenerator:Int = 0;
        var _disposed:Bool = false;
        var _secondsElapsed:Float = 0;

        public function new(k:BundlePurchaseExtraInfoCatalogWidget, _arg_2:HabboCatalog)
        {
            this._widget = k;
            this._catalog = _arg_2;
            this._items = new Map();
            this._catalog.registerUpdateReceiver(this, 10);
        }

        
        public var disposed(get,set):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
public function  set_disposed(k:Bool):Bool        {
            return this._disposed = k;
        }

        public function dispose()
        {
            var k:ExtraInfoListItem = null;
            if (!this.disposed)
            {
                this._catalog.removeUpdateReceiver(this);
                this._widget = null;
                this._catalog = null;
                final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._items = null;
                this.disposed = true;
            }
        }

        public function clear()
        {
            var k:ExtraInfoListItem = null;
            while (this._widget.window.numChildren > 0)
            {
                this._widget.window.removeChildAt(0);
            }
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._items = new Map();
            this.render();
        }

        public function addItem(k:ExtraInfoItemData):Int
        {
            var _local_2:ExtraInfoListItem = null;
            var _local_3= this._idGenerator++;
            switch (k.type)
            {
                case ExtraInfoItemData._Str_13400:
                    _local_2 = new ExtraInfoPromoItem(this._widget, _local_3, k, this._catalog);
                    
                case ExtraInfoItemData._Str_14719:
                    _local_2 = new ExtraInfoBundlesInfoItem(this._widget, _local_3, k, this._catalog);
                    
                case ExtraInfoItemData._Str_14097:
                    _local_2 = new ExtraInfoDiscountValueItem(_local_3, k, this._catalog);
                    
                case ExtraInfoItemData._Str_16957:
                    _local_2 = new ExtraInfoBonusBadgeItem(_local_3, k, this._catalog);
                    
                case ExtraInfoItemData._Str_18371:
                    _local_2 = new ExtraInfoBonusAchievementItem(_local_3, k);
                    
            }
            _local_2._Str_13645 = this._secondsElapsed;
            this._items.add(_local_3, _local_2);
            var _local_4:IWindow = _local_2.getRenderedWindow();
            _local_4.width = this._widget.window.width;
            this._widget.window.addChild(_local_4);
            this._Str_22743();
            this.render();
            return _local_2.id;
        }

        public function removeItem(k:Int)
        {
            var _local_2= this.getItem(k);
            if (_local_2 != null)
            {
                _local_2._Str_14104 = this._secondsElapsed;
                if (_local_2.alignment == ExtraInfoListItem.ALIGN_OVERLAY)
                {
                    this._Str_20572(_local_2.id);
                }
                this.render();
            }
        }

        public function getItem(k:Int):ExtraInfoListItem
        {
            return cast(this._items.getValue(k), ExtraInfoListItem);
        }

        function _Str_20572(k:Int)
        {
            var _local_2= this.getItem(k);
            this._widget.window.removeChild(_local_2.getRenderedWindow());
            this._items.remove(k);
        }

        function _Str_19328(k:Float, _arg_2:Bool=false):Float
        {
            if (_arg_2)
            {
                return 1 - Math.abs(Math.cos((((this._secondsElapsed - k) / _Str_9363) * (Math.PI / 2))));
            }
            return 1 - Math.abs(Math.sin((((this._secondsElapsed - k) / _Str_9363) * (Math.PI / 2))));
        }

        function render()
        {
            var _local_4:ExtraInfoListItem = null;
            var _local_5:IWindow = null;
            var _local_6 = Math.NaN;
            var k = 0;
            var _local_2= this._widget.window.height;
            var _local_3= this._items.getValues();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                _local_5 = _local_4.getRenderedWindow();
                _local_6 = 0;
                if ((this._secondsElapsed - _Str_9363) <= _local_4._Str_13645)
                {
                    _local_6 = this._Str_19328(_local_4._Str_13645);
                }
                if (_local_4._Str_24857)
                {
                    _local_6 = this._Str_19328(_local_4._Str_14104, true);
                    if (this._secondsElapsed > (_local_4._Str_14104 + _Str_9363))
                    {
                        this._Str_20572(_local_4.id);
                        break;
                    }
                }
                if (_local_4.alignment == ExtraInfoListItem.ALIGN_TOP)
                {
                    _local_5.y = k;
                    _local_5.y = Std.int(_local_5.y - (_local_6 * Math.min(_local_5.height, _Str_13502)));
                    k = (k + _local_5.height);
                }
                else
                {
                    if (_local_4.alignment == ExtraInfoListItem.ALIGN_BOTTOM)
                    {
                        _local_5.y = (_local_2 - _local_5.height);
                        _local_5.y = Std.int(_local_5.y + (_local_6 * Math.min(_local_5.height, _Str_13502)));
                        _local_2 = (_local_2 - _local_5.height);
                    }
                    else
                    {
                        if (_local_4.alignment == ExtraInfoListItem.ALIGN_OVERLAY)
                        {
                            _local_5.y = 0;
                        }
                    }
                }
            }
        }

        function _Str_22743()
        {
            var _local_2:ExtraInfoListItem = null;
            var k= (this._widget.window.numChildren - 1);
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (_local_2._Str_22324)
                {
                    this._widget.window.setChildIndex(_local_2.getRenderedWindow(), k);
                }
            }
        }

        var _Str_25119(get,never):Bool;
function  get__Str_25119():Bool
        {
            return true;
        }

        public function update(k:UInt)
        {
            this._secondsElapsed = (this._secondsElapsed + (k / 1000));
            if (this._Str_25119)
            {
                this.render();
            }
        }
    }

