package com.sulake.habbo.inventory.furni
;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.wired_trading.requirements.WiredTradeRequirementsModel;

     class FurniGridView 
    {
        static inline final _Str_20122= 0;
        static inline final _Str_16787= 1;
        static inline final _Str_18697= 2;

        var _grid:IItemGridWindow;
        var _items:Vector<GroupItem>;
        var _showFloorItems:Bool = true;
        var _showWallItems:Bool = true;
        var _placement:Int = 0;
        var _showingRentedItems:Bool = false;
        var _passedItems:Vector<GroupItem>;
        var _pages:IItemListWindow;
        var _pageTemplate:IRegionWindow;
        var _itemsPerPage:Int = 200;
        var _currentPage:Int = -1;
        var _currentPageItems:Vector<GroupItem>;
        var _filter:String = "";
        var _wiredRequirements:WiredTradeRequirementsModel;

        public function new(k:IItemGridWindow, _arg_2:IItemListWindow)
        {
            this._grid = k;
            this._grid.shouldRebuildGridOnResize = false;
            this._items = new Vector<GroupItem>(0);
            this._passedItems = new Vector<GroupItem>(0);
            this._pages = _arg_2;
            if (this._pages != null)
            {
                this._pageTemplate = Std.downcast(this._pages.removeListItemAt(0) , IRegionWindow);
            }
        }

        public var _Str_26072(get,never):Int;
public function  get__Str_26072():Int
        {
            return ASCompat.toInt(this._grid.numGridItems);
        }

        public var _Str_12561(get,never):Vector<GroupItem>;
public function  get__Str_12561():Vector<GroupItem>
        {
            return this._currentPageItems;
        }

        var _Str_8849(get,never):Int;
function  get__Str_8849():Int
        {
            return Std.int((this._passedItems.length / this._itemsPerPage) + 1);
        }

        public function dispose()
        {
            this._grid = null;
            this._items = null;
        }

        public function _Str_25425()
        {
            if (this._grid != null)
            {
                this._grid.removeGridItems();
            }
            this._grid.destroyGridItems();
        }

        public function _Str_25694(k:Int, _arg_2:String, _arg_3:Bool, _arg_4:String, _arg_5:Int)
        {
            this._showFloorItems = ((k == 0) || (k == 1));
            this._showWallItems = ((k == 0) || (k == 2));
            this._showingRentedItems = _arg_3;
            this._placement = _arg_5;
            this._filter = _arg_4.toLowerCase();
            this.update();
        }

        public function setWiredRequirements(
            requirements:WiredTradeRequirementsModel)
        {
            this._wiredRequirements = requirements;
            this.update();
        }

        public function _Str_9854(k:GroupItem)
        {
            if (this._Str_19541(k))
            {
                this.update();
            }
        }

        public function _Str_15980():IWindowContainer
        {
            if (this._grid.numGridItems == 0)
            {
                return null;
            }
            return Std.downcast(this._grid.getGridItemAt(0) , IWindowContainer);
        }

        public function _Str_25722(k:Vector<GroupItem>)
        {
            this._items = k;
            this.update();
        }

        function update()
        {
            var item:GroupItem = null;
            var changes = false;
            var i = 0;
            var currentItems= new Vector<GroupItem>(0);
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                if (this._Str_19541(item))
                {
                    currentItems.push(item);
                }
            }
            if (this._showingRentedItems)
            {
                currentItems = ASCompat.ASVector.sort(currentItems, function (k:GroupItem, _arg_2:GroupItem):Float
                {
                    var _local_3:ASAny = k._Str_3205();
                    var _local_4:ASAny = _arg_2._Str_3205();
                    var _local_5:ASAny = (ASCompat.toInt(_local_4.hasRentPeriodStarted) - ASCompat.toInt(_local_3.hasRentPeriodStarted));
                    return ASCompat.toNumber((_local_5 != 0) ? ASCompat.toNumber(_local_5) : ASCompat.toNumber(ASCompat.toNumber(_local_3.secondsToExpiration) - ASCompat.toNumber(_local_4.secondsToExpiration)));
                });
            }
            if (currentItems.length == this._passedItems.length)
            {
                changes = false;
                i = 0;
                while (i < currentItems.length)
                {
                    if (currentItems[i] != this._passedItems[i])
                    {
                        changes = true;
                        break;
                    }
                    i = (i + 1);
                }
                if (!changes)
                {
                    return;
                }
            }
            this._passedItems = currentItems;
            this._Str_20040(this._currentPage, true);
            this._Str_20352();
        }

        function _Str_20040(k:Int, _arg_2:Bool=false)
        {
            if (k > -1)
            {
                if (((this._currentPage == k) && (!_arg_2)))
                {
                    return;
                }
            }
            else
            {
                k = 0;
            }
            this._currentPage = k;
            if (this._currentPage >= this._Str_8849)
            {
                this._currentPage = (this._Str_8849 - 1);
            }
            this._currentPage = Std.int(Math.max(this._currentPage, 0));
            this._currentPageItems = new Vector<GroupItem>(0);
            this._Str_25425();
            var _local_3= (this._currentPage * this._itemsPerPage);
            var _local_4= (_local_3 + this._itemsPerPage);
            _local_4 = Std.int(Math.min(_local_4, this._passedItems.length));
            var _local_5= _local_3;
            while (_local_5 < _local_4)
            {
                this._grid.addGridItem(this._passedItems[_local_5].window);
                this._currentPageItems.push(this._passedItems[_local_5]);
                _local_5++;
            }
        }

        function _Str_25938(k:GroupItem)
        {
        }

        function _Str_20352()
        {
            var _local_2:IRegionWindow = null;
            var _local_3 = 0;
            var _local_4:ITextWindow = null;
            if (this._pages == null)
            {
                return;
            }
            var k= this._Str_8849;
            this._pages.visible = (k > 1);
            if (this._currentPage >= k)
            {
                this._currentPage = (k - 1);
            }
            this._currentPage = Std.int(Math.max(this._currentPage, 0));
            if (this._Str_8849 != this._pages.numListItems)
            {
                final _iter_ = this._pages; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_.iterator))
                {
_local_2  = _tmp_;
                    _local_2.removeEventListener(WindowMouseEvent.CLICK, this._Str_12810);
                }
                this._pages.destroyListItems();
                _local_3 = 0;
                while (_local_3 < k)
                {
                    _local_2 = Std.downcast(this._pageTemplate.clone() , IRegionWindow);
                    _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_12810);
                    _local_2.addEventListener(WindowMouseEvent.OVER, this._Str_12810);
                    _local_2.addEventListener(WindowMouseEvent.OUT, this._Str_12810);
                    _local_2.id = _local_3;
                    _local_2.name = ("page_" + Std.string(_local_3));
                    this._pages.addListItem(_local_2);
                    _local_3++;
                }
            }
            _local_3 = 0;
            while (_local_3 < k)
            {
                _local_2 = Std.downcast(this._pages.getListItemAt(_local_3) , IRegionWindow);
                _local_4 = Std.downcast(_local_2.findChildByTag("PAGE") , ITextWindow);
                _local_4.caption = Std.string(_local_3);
                if (_local_3 == this._currentPage)
                {
                    _local_4.underline = true;
                    _local_4.textColor = 0xFF0000;
                }
                else
                {
                    _local_4.underline = false;
                    _local_4.textColor = 0;
                }
                _local_3++;
            }
        }

        function _Str_12810(k:WindowMouseEvent)
        {
            var _local_2= k.window.id;
            var _local_3= Std.downcast(Std.downcast(k.target , IWindowContainer).findChildByTag("PAGE") , ITextWindow);
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    this._Str_20040(_local_2);
                    this._Str_20352();
                    return;
                case WindowMouseEvent.OVER:
                    _local_3.textColor = 0xFF0000;
                    return;
                case WindowMouseEvent.OUT:
                    if (_local_2 != this._currentPage)
                    {
                        _local_3.textColor = 0;
                    }
                    return;
            }
        }

        function _Str_19541(k:GroupItem):Bool
        {
            var _local_2:String = null;
            var _local_3:String = null;
            if (((!this._showFloorItems) && (!k.isWallItem)))
            {
                return false;
            }
            if (((!this._showWallItems) && k.isWallItem))
            {
                return false;
            }
            if (this._showingRentedItems != k._Str_3459)
            {
                return false;
            }
            if (((this._placement == _Str_16787) && (k.flatId == -1)))
            {
                return false;
            }
            if (((this._placement == _Str_18697) && (k.flatId > -1)))
            {
                return false;
            }
            if (this._filter.length > 0)
            {
                _local_2 = k.name.toLowerCase();
                _local_3 = k.description.toLowerCase();
                if (((_local_2.indexOf(this._filter) == -1) && (_local_3.indexOf(this._filter) == -1)))
                {
                    return false;
                }
            }
            if (this._wiredRequirements != null
                && !this._wiredRequirements.canOfferFurni(k))
            {
                return false;
            }
            return true;
        }
    }

