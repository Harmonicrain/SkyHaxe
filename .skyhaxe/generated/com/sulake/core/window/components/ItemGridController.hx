package com.sulake.core.window.components
;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.iterators.ItemGridIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class ItemGridController extends ItemListController implements IItemGridWindow 
    {
        var _containerResizeToColumns:Bool = false;
        var _explicitVerticalSpacing:Bool = false;
        var _verticalSpacing:Int = 0;
        var _shouldRebuildGridOnResize:Bool = true;
        var _isGridRebuilding:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _horizontal = (!(_arg_2 == WindowType.WINDOW_TYPE_ITEMGRID_HORIZONTAL));
            _scaleToFitItems = true;
            if (!_horizontal)
            {
                throw new ASError("Horizontal item grid not yet implemented!");
            }
        }

        override public function  set_spacing(k:Int):Int        {
            var _local_2:UInt = numListItems;
            if (this._explicitVerticalSpacing == false)
            {
                while (_local_2-- > 0)
                {
                    cast(getListItemAt(_local_2), IItemListWindow).spacing = k;
                }
            }
            return super.spacing = k;
        }

        override public function  set_background(k:Bool):Bool        {
            super.background = k;
            var _local_2:UInt = 0;
            while (_local_2 < (numListItems : UInt))
            {
                getListItemAt(_local_2).background = k;
                _local_2++;
            }
return k;
        }

        override public function  set_color(k:UInt):UInt        {
            super.color = k;
            var _local_2:UInt = 0;
            while (_local_2 < (numListItems : UInt))
            {
                getListItemAt(_local_2).color = k;
                _local_2++;
            }
return k;
        }

        override public function  set_autoArrangeItems(k:Bool):Bool        {
            super.autoArrangeItems = k;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this.numColumns)
            {
                cast(getListItemAt(_local_2), IItemListWindow).autoArrangeItems = k;
                _local_2++;
            }
return k;
        }

        override public function  get_scrollStepH():Float
        {
            if (_scrollStepH >= 0)
            {
                return _scrollStepH;
            }
            return _horizontal ? (0.1 * scrollableRegion.height) : (scrollableRegion.width / this.numColumns);
        }

        override public function  get_scrollStepV():Float
        {
            if (_scrollStepV >= 0)
            {
                return _scrollStepV;
            }
            return _horizontal ? (scrollableRegion.height / this.numRows) : (0.1 * scrollableRegion.width);
        }

        
        public var shouldRebuildGridOnResize(get,set):Bool;
public function  get_shouldRebuildGridOnResize():Bool
        {
            return this._shouldRebuildGridOnResize;
        }
public function  set_shouldRebuildGridOnResize(k:Bool):Bool        {
            return this._shouldRebuildGridOnResize = k;
        }

        public var verticalSpacing(never,set):Int;
public function  set_verticalSpacing(k:Int):Int        {
            this._verticalSpacing = k;
            this._explicitVerticalSpacing = true;
            var _local_2:UInt = numListItems;
            while (_local_2-- > 0)
            {
                cast(getListItemAt(_local_2), IItemListWindow).spacing = k;
            }
return k;
        }

        override public function  get_iterator():IIterator
        {
            return new ItemGridIterator(this);
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3= super.update(k, _arg_2);
            switch (_arg_2.type)
            {
                case WindowEvent.WINDOW_EVENT_RESIZED:
                    if (this._shouldRebuildGridOnResize)
                    {
                        this.rebuildGridStructure();
                    }
                    
                case WindowMouseEvent.WHEEL:
                    if (_horizontal)
                    {
                        scrollV = (scrollV - (cast(_arg_2, WindowMouseEvent).delta * 0.01));
                    }
                    else
                    {
                        scrollH = (scrollH - (cast(_arg_2, WindowMouseEvent).delta * 0.01));
                    }
                    _local_3 = true;
                    
            }
            return _local_3;
        }

        public var numGridItems(get,never):UInt;
public function  get_numGridItems():UInt
        {
            var k:UInt = numListItems;
            var _local_2:UInt = 0;
            while (k-- > 0)
            {
                _local_2 = (_local_2 + cast(getListItemAt(k), IItemListWindow).numListItems);
            }
            return _local_2;
        }

        public var numColumns(get,never):UInt;
public function  get_numColumns():UInt
        {
            return numListItems;
        }

        public var numRows(get,never):UInt;
public function  get_numRows():UInt
        {
            var k:UInt = 0;
            var _local_2= this.numColumns;
            var _local_3:UInt = 0;
            while (_local_3 < _local_2)
            {
                k = Std.int(Math.max(k, cast(getListItemAt(_local_3), IItemListWindow).numListItems));
                _local_3++;
            }
            return k;
        }

        public function addGridItem(k:IWindow):IWindow
        {
            var _local_2= this._Str_16044(k);
            return k;
        }

        public function addGridItemAt(k:IWindow, _arg_2:UInt):IWindow
        {
            this._Str_22897(k, Std.int(Math.min(this.numGridItems, _arg_2)));
            return k;
        }

        public function getGridItemAt(k:UInt):IWindow
        {
            var _local_2= this._Str_6836(k);
            if (_local_2 == null)
            {
                return null;
            }
            return _local_2.getListItemAt(Std.int(k / this.numColumns));
        }

        public function getGridItemByID(k:UInt):IWindow
        {
            var _local_3:IItemListWindow = null;
            var _local_4:IWindow = null;
            var _local_5:UInt = 0;
            var _local_2= this.numColumns;
            _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_3 = Std.downcast(getListItemAt(_local_5) , IItemListWindow);
                _local_4 = _local_3.getListItemByID(k);
                if (_local_4 != null)
                {
                    return _local_4;
                }
                _local_5++;
            }
            return null;
        }

        public function getGridItemByName(k:String):IWindow
        {
            var _local_3:IItemListWindow = null;
            var _local_4:IWindow = null;
            var _local_5:UInt = 0;
            var _local_2= this.numColumns;
            _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_3 = Std.downcast(getListItemAt(_local_5) , IItemListWindow);
                _local_4 = _local_3.getListItemByName(k);
                if (_local_4 != null)
                {
                    return _local_4;
                }
                _local_5++;
            }
            return null;
        }

        public function getGridItemByTag(k:String):IWindow
        {
            var _local_3:IItemListWindow = null;
            var _local_4:IWindow = null;
            var _local_5:UInt = 0;
            var _local_2= this.numColumns;
            _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_3 = Std.downcast(getChildAt(ASCompat.toInt(_local_5)) , IItemListWindow);
                _local_4 = _local_3.getListItemByTag(k);
                if (_local_4 != null)
                {
                    return _local_4;
                }
                _local_5++;
            }
            return null;
        }

        public function getGridItemIndex(k:IWindow):Int
        {
            var _local_2= this._Str_22998(k);
            if (_local_2 == null)
            {
                return -1;
            }
            return ASCompat.toInt((_local_2.getListItemIndex(k) * this.numColumns) + this._Str_22838(_local_2));
        }

        public function removeGridItem(k:IWindow):IWindow
        {
            var _local_2= this.getGridItemIndex(k);
            if (_local_2 == -1)
            {
                return null;
            }
            if (this._Str_24877(_local_2) != k)
            {
                throw new ASError("Item grid is out of order!");
            }
            var _local_3= this._Str_6836(_local_2);
            if (!_horizontal)
            {
                _local_3.width = Std.int(_local_3.scrollableRegion.width);
            }
            else
            {
                _local_3.height = Std.int(_local_3.scrollableRegion.height);
            }
            return k;
        }

        public function removeGridItemAt(k:Int):IWindow
        {
            return this.removeGridItem(this.getGridItemAt(k));
        }

        public function setGridItemIndex(k:IWindow, _arg_2:Int)
        {
            if (this.removeGridItem(k) == null)
            {
                throw new ASError("Item not found in grid!");
            }
            addListItemAt(k, _arg_2);
        }

        public function swapGridItems(k:IWindow, _arg_2:IWindow)
        {
            throw new ASError("ItemGridWindow / Unimplemented method!");
        }

        public function swapGridItemsAt(k:Int, _arg_2:Int)
        {
            this.swapGridItems(this.getGridItemAt(k), this.getGridItemAt(_arg_2));
        }

        public function removeGridItems()
        {
            var _local_2:IItemListWindow = null;
            var k= this.numColumns;
            var _local_3:UInt = 0;
            var _local_4= this._shouldRebuildGridOnResize;
            this._shouldRebuildGridOnResize = false;
            try
            {
                while (_local_3 < k)
                {
                    _local_2 = cast(getListItemAt(_local_3), IItemListWindow);
                    if (_local_2 != null)
                    {
                        _local_2.removeListItems();
                        if (!_horizontal)
                        {
                            _local_2.width = 0;
                        }
                        else
                        {
                            _local_2.height = 0;
                        }
                    }
                    _local_3++;
                }
            }
            catch (_m2_finally_error:ASAny)
            {
                this._shouldRebuildGridOnResize = _local_4;

                throw _m2_finally_error;
            }
                this._shouldRebuildGridOnResize = _local_4;

        }

        public function destroyGridItems()
        {
            var _local_2:IItemListWindow = null;
            var k= this.numColumns;
            var _local_3:UInt = 0;
            var _local_4= this._shouldRebuildGridOnResize;
            this._shouldRebuildGridOnResize = false;
            try
            {
                while (_local_3 < k)
                {
                    _local_2 = cast(getListItemAt(_local_3), IItemListWindow);
                    if (_local_2 != null)
                    {
                        _local_2.destroyListItems();
                        if (!_horizontal)
                        {
                            _local_2.width = 0;
                        }
                        else
                        {
                            _local_2.height = 0;
                        }
                    }
                    _local_3++;
                }
            }
            catch (_m2_finally_error:ASAny)
            {
                this._shouldRebuildGridOnResize = _local_4;

                throw _m2_finally_error;
            }
                this._shouldRebuildGridOnResize = _local_4;

            destroyListItems();
        }

        function _Str_24723(k:WindowEvent, _arg_2:IWindow)
        {
        }

        function _Str_26265(k:WindowEvent)
        {
            var _local_2:IWindow = null;
            if (k.type == WindowEvent.WINDOW_EVENT_DESTROYED)
            {
                _local_2 = k.target ;
                this.removeGridItem(_local_2);
            }
        }

        function _Str_22838(k:IItemListWindow):Int
        {
            return getListItemIndex(k);
        }

        function _Str_6836(k:UInt):IItemListWindow
        {
            return Std.downcast(getListItemAt((k % this.numColumns)) , IItemListWindow);
        }

        public function _Str_26410(k:UInt):UInt
        {
            return k % this.numColumns;
        }

        public function _Str_16931(k:UInt):UInt
        {
            return Std.int(k / this.numColumns);
        }

        override public function populate(k:Array<ASAny>)
        {
            var _local_5:IItemListWindow = null;
            var _local_7:IWindow = null;
            var _local_8:IItemListWindow = null;
            var _local_9 = 0;
            var _local_10 = false;
            var _local_2= autoArrangeItems;
            this.autoArrangeItems = false;
            var _local_3= ASCompat.toInt(this.numGridItems);
            var _local_4= ASCompat.toInt(this.numColumns);
            var _local_6:Array<ASAny> = [];
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_7  = _tmp_;
                if (_local_4 == 0)
                {
                    this._Str_14060(_local_7);
                    _local_4++;
                }
                else
                {
                    if (_local_3 > 0)
                    {
                        _local_8 = this._Str_6836(((_local_3 > 0) ? (_local_3 - 1) : 0));
                        _local_9 = getListItemIndex(_local_8);
                        _local_10 = ((_local_9 > -1) ? (_local_9 == (_local_4 - 1)) : true);
                        if (_local_10)
                        {
                            if (_local_8.numListItems == 1)
                            {
                                if ((_local_8.right + _local_7.width) <= _w)
                                {
                                    this._Str_14060(_local_7);
                                    continue;
                                }
                            }
                        }
                        _local_5 = Std.downcast(getListItemAt((_local_10 ? 0 : (_local_9 + 1))) , IItemListWindow);
                    }
                    else
                    {
                        _local_5 = Std.downcast(getListItemAt(0) , IItemListWindow);
                    }
                    _local_5.addListItem(_local_7);
                    _local_3++;
                    if (_local_7.width > _local_5.width)
                    {
                        _local_5.width = _local_7.width;
                    }
                    if (_local_7.bottom > _local_5.height)
                    {
                        _local_5.height = _local_7.bottom;
                    }
                }
            }
            this.autoArrangeItems = _local_2;
        }

        function _Str_22998(k:IWindow):IItemListWindow
        {
            var _local_3:IItemListWindow = null;
            var _local_2= this.numColumns;
            while (_local_2-- > 0)
            {
                _local_3 = cast(getListItemAt(_local_2), IItemListWindow);
                if (_local_3.getListItemIndex(k) > -1)
                {
                    return _local_3;
                }
            }
            return null;
        }

        function _Str_16044(k:IWindow):IItemListWindow
        {
            var _local_3:IItemListWindow = null;
            var _local_4:IItemListWindow = null;
            var _local_5 = 0;
            var _local_6 = false;
            if (this.numColumns == 0)
            {
                return this._Str_14060(k);
            }
            var _local_2= this.numGridItems;
            if (_local_2 > 0)
            {
                _local_4 = this._Str_6836(ASCompat.toUInt((_local_2 > 0) ? (_local_2 - 1) : 0));
                _local_5 = getListItemIndex(_local_4);
                _local_6 = ((_local_5 > -1) ? ((_local_5 : UInt) == (this.numColumns - 1)) : true);
                if (_local_6)
                {
                    if (_local_4.numListItems == 1)
                    {
                        if ((_local_4.right + k.width) <= _w)
                        {
                            return this._Str_14060(k);
                        }
                    }
                }
                _local_3 = Std.downcast(getListItemAt((_local_6 ? 0 : (_local_5 + 1))) , IItemListWindow);
            }
            else
            {
                _local_3 = Std.downcast(getListItemAt(0) , IItemListWindow);
            }
            _local_3.addListItem(k);
            if (k.width > _local_3.width)
            {
                _local_3.width = k.width;
            }
            if (k.bottom > _local_3.height)
            {
                _local_3.height = k.bottom;
            }
            return _local_3;
        }

        function _Str_14060(k:IWindow):IItemListWindow
        {
            var _local_2= Std.downcast(_context.create(((_name + "_COLUMN_") + Std.string(numListItems)), null, WindowType.WINDOW_TYPE_ITEMLIST_VERTICAL, WindowStyle.WINDOW_STYLE_DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), new Rectangle(0, 0, Math.max(k.width, 0), Math.max(k.height, 0)), this._Str_24723, null, numListItems, null, "", [WindowController.TAG_INTERNAL, WindowController.TAG_EXCLUDE]) , IItemListWindow);
            _local_2.isPartOfGridWindow = true;
            _local_2.background = background;
            _local_2.color = color;
            _local_2.spacing = (this._explicitVerticalSpacing ? this._verticalSpacing : _spacing);
            addListItem(_local_2);
            _local_2.addListItem(k);
            return _local_2;
        }

        function _Str_26203(k:UInt)
        {
            var _local_2= Std.downcast(removeChildAt(ASCompat.toInt(k)) , IItemListWindow);
            if (_local_2 != null)
            {
                _local_2.dispose();
            }
        }

        function _Str_22897(k:IWindow, _arg_2:UInt)
        {
            var _local_5:IItemListWindow = null;
            var _local_7:IWindow = null;
            var _local_8:UInt = 0;
            var _local_3= this.numGridItems;
            var _local_4= ASCompat.toInt(_local_3 - 1);
            var _local_6= this.numColumns;
            var _local_9 = 0;
            while ((_local_9 : UInt) < _local_6)
            {
                cast(getListItemAt(_local_9), IItemListWindow).autoArrangeItems = false;
                _local_9++;
            }
            if (_local_3 <= _arg_2)
            {
                this._Str_16044(k);
            }
            else
            {
                if (this.numRows == 1)
                {
                    _local_7 = this.getGridItemAt(_local_4);
                    _local_5 = this._Str_16044(_local_7);
                    _local_4--;
                }
                while ((_local_4 : UInt) >= _arg_2)
                {
                    _local_7 = this.getGridItemAt(_local_4);
                    _local_8 = this._Str_16931((_local_4 + 1));
                    _local_5 = this._Str_6836((_local_4 + 1));
                    _local_5.addListItemAt(_local_7, _local_8);
                    _local_4--;
                }
                this._Str_6836(_arg_2).addListItemAt(k, Std.int(_arg_2 / this.numColumns));
            }
            var _local_10:UInt = 0;
            _local_6 = this.numColumns;
            _local_9 = 0;
            while ((_local_9 : UInt) < _local_6)
            {
                _local_5 = cast(getListItemAt(_local_9), IItemListWindow);
                _local_5.autoArrangeItems = true;
                _local_5.height = Std.int(_local_5.scrollableRegion.height);
                _local_10 = Std.int(Math.max(_local_10, _local_5.height));
                _local_9++;
            }
            _container.height = ASCompat.toInt(_local_10);
        }

        function _Str_24877(k:UInt):IWindow
        {
            var _local_7:IWindow = null;
            var _local_2= this._Str_16931(k);
            var _local_3= this._Str_6836(k);
            var _local_4= _local_3.removeListItemAt(ASCompat.toInt(_local_2));
            var _local_5= this.numGridItems;
            var _local_6= k;
            if (_local_4 == null)
            {
                return null;
            }
            var _local_8 = 0;
            while ((_local_8 : UInt) < this.numColumns)
            {
                cast(getListItemAt(_local_8), IItemListWindow).autoArrangeItems = false;
                _local_8++;
            }
            while (_local_6 < _local_5)
            {
                _local_2 = this._Str_16931(_local_6);
                _local_7 = this.getGridItemAt((_local_6 + 1));
                _local_3 = this._Str_6836(_local_6);
                _local_3.addListItemAt(_local_7, _local_2);
                _local_6++;
            }
            var _local_9:UInt = 0;
            _local_8 = 0;
            while ((_local_8 : UInt) < this.numColumns)
            {
                _local_3 = cast(getListItemAt(_local_8), IItemListWindow);
                _local_3.autoArrangeItems = true;
                _local_3.height = Std.int(_local_3.scrollableRegion.height);
                _local_9 = Std.int(Math.max(_local_9, _local_3.height));
                _local_8++;
            }
            _container.height = ASCompat.toInt(_local_9);
            return _local_4;
        }

        public function rebuildGridStructure()
        {
            var _local_4:IItemListWindow = null;
            var _local_5:IWindow = null;
            var _local_7 = 0;
            var _local_8:UInt = 0;
            var k= ASCompat.toInt(this.numGridItems);
            var _local_2:Array<ASAny> = [];
            var _local_3= ASCompat.toInt(this.numColumns);
            if (this._isGridRebuilding)
            {
                return;
            }
            this._isGridRebuilding = true;
            var _local_6= autoArrangeItems;
            this.autoArrangeItems = false;
            while (k > 0)
            {
                _local_7 = 0;
                while (_local_7 < _local_3)
                {
                    _local_4 = Std.downcast(getListItemAt(_local_7) , IItemListWindow);
                    _local_5 = _local_4.removeListItemAt(0);
                    _local_2.push(_local_5);
                    if (--k < 1)
                    {
                        break;
                    }
                    _local_7++;
                }
            }
            destroyListItems();
            this.autoArrangeItems = _local_6;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_5  = _tmp_;
                this.addGridItem(_local_5);
            }
            if (this._containerResizeToColumns)
            {
                _local_8 = 0;
                _local_7 = 0;
                while ((_local_7 : UInt) < this.numColumns)
                {
                    _local_4 = cast(getListItemAt(_local_7), IItemListWindow);
                    _local_4.autoArrangeItems = true;
                    _local_4.height = Std.int(_local_4.scrollableRegion.height);
                    _local_8 = Std.int(Math.max(_local_8, _local_4.height));
                    _local_7++;
                }
                _container.height = ASCompat.toInt(_local_8);
            }
            this._isGridRebuilding = false;
        }

        
        public var containerResizeToColumns(get,set):Bool;
public function  set_containerResizeToColumns(k:Bool):Bool        {
            return this._containerResizeToColumns = k;
        }
public function  get_containerResizeToColumns():Bool
        {
            return this._containerResizeToColumns;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.CONTAINER_RESIZE_TO_COLUMNS, this.containerResizeToColumns));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.CONTAINER_RESIZE_TO_COLUMNS:
                        this.containerResizeToColumns = ASCompat.asBoolean(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }
    }

