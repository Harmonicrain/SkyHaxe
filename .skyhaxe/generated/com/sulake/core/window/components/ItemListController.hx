package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.IInputProcessorRoot;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowStyle;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.graphics.WindowRedrawFlag;
    import com.sulake.core.window.iterators.ItemListIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.SmoothScroller;

     class ItemListController extends WindowController implements IItemListWindow implements  IInputProcessorRoot 
    {
        var _disableAutoDrag:Bool = false;
        var _isPartOfGridWindow:Bool = false;
        var _scrollOffsetH:Float = Math.NaN;
        var _scrollOffsetV:Float = Math.NaN;
        var _scrollAreaWidth:Float = Math.NaN;
        var _scrollAreaHeight:Float = Math.NaN;
        var _container:IWindowContainer;
        var _resizing:Bool = false;
        var _updating:Bool = false;
        var _spacing:Int = 0;
        var _horizontal:Bool = false;
        var _scrollStepH:Float = -1;
        var _scrollStepV:Float = -1;
        var _arrangeListItems:Bool = false;
        var _scaleToFitItems:Bool = false;
        var _resizeOnItemUpdate:Bool = false;
        var _dragStartX:Float = Math.NaN;
        var _dragStartY:Float = Math.NaN;
        var _dragStartScrollH:Float = Math.NaN;
        var _dragStartScrollV:Float = Math.NaN;
        var _dragging:Bool = false;
        var _horizontalSmoothScroller:SmoothScroller;
        var _verticalSmoothScroller:SmoothScroller;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._scrollOffsetH = 0;
            this._scrollOffsetV = 0;
            this._scrollAreaWidth = 0;
            this._scrollAreaHeight = 0;
            this._horizontal = (_arg_2 == WindowType.WINDOW_TYPE_ITEMLIST_HORIZONTAL);
            var _local_12= _arg_5.getWindowFactory().getThemeManager();
            this._spacing = ASCompat.toInt(_local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.SPACING).value);
            this._arrangeListItems = _local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.AUTO_ARRANGE_ITEMS).value;
            this._scaleToFitItems = _local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.SCALE_TO_FIT_ITEMS).value;
            this._resizeOnItemUpdate = _local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.RESIZE_ON_ITEM_UPDATE).value;
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _drawable = (_background || (!testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
            this._container = Std.downcast(_context.create("_CONTAINER", "", WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT, ((ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_SCALE_FIXED)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), new Rectangle(0, 0, width, height), null, this, 0, null, "", [WindowController.TAG_INTERNAL, WindowController.TAG_EXCLUDE]) , IWindowContainer);
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.containerEventHandler);
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_REMOVED, this.containerEventHandler);
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this.containerEventHandler);
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY, this.containerEventHandler);
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this.containerEventHandler);
            this._container.clipping = clipping;
            this.resizeOnItemUpdate = this._resizeOnItemUpdate;
        }

        
        public var spacing(get,set):Int;
public function  get_spacing():Int
        {
            return this._spacing;
        }
public function  set_spacing(k:Int):Int        {
            if (k != this._spacing)
            {
                this._spacing = k;
                this.updateScrollAreaRegion();
            }
return k;
        }

        
        public var scrollH(get,set):Float;
public function  get_scrollH():Float
        {
            return this._scrollOffsetH;
        }

        
        public var scrollV(get,set):Float;
public function  get_scrollV():Float
        {
            return this._scrollOffsetV;
        }

        public var maxScrollH(get,never):Int;
public function  get_maxScrollH():Int
        {
            return Std.int(Math.max(0, (this._scrollAreaWidth - width)));
        }

        public var maxScrollV(get,never):Int;
public function  get_maxScrollV():Int
        {
            return Std.int(Math.max(0, (this._scrollAreaHeight - height)));
        }

        
        public var isPartOfGridWindow(get,set):Bool;
public function  get_isPartOfGridWindow():Bool
        {
            return this._isPartOfGridWindow;
        }
public function  set_isPartOfGridWindow(k:Bool):Bool        {
            return this._isPartOfGridWindow = k;
        }

        public var scrollableWindow(get,never):IWindow;
public function  get_scrollableWindow():IWindow
        {
            return this;
        }

        public var visibleRegion(get,never):Rectangle;
public function  get_visibleRegion():Rectangle
        {
            return new Rectangle((this._scrollOffsetH * this.maxScrollH), (this._scrollOffsetV * this.maxScrollV), width, height);
        }

        public var scrollableRegion(get,never):Rectangle;
public function  get_scrollableRegion():Rectangle
        {
            return this._container.rectangle;
        }
public function  set_scrollH(k:Float):Float        {
            this.setScrollH(k, false);
return k;
        }

        function setScrollH(k:Float, smooth:Bool)
        {
            var _local_2:WindowEvent = null;
            var _local_3 = Math.NaN;
            if (k < 0)
            {
                k = 0;
            }
            if (k > 1)
            {
                k = 1;
            }
            _local_3 = (k - this._scrollOffsetH);
            if (k != this._scrollOffsetH)
            {
                this._scrollOffsetH = k;
                this._container.x = Std.int(-this._scrollOffsetH * this.maxScrollH);
                _context.invalidate(this._container, this.visibleRegion, WindowRedrawFlag.REDRAW);
                if (_events != null)
                {
                    _local_2 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_SCROLL, this, null);
                    _events.dispatchEvent(_local_2);
                    _local_2.recycle();
                }
            }
            if (((!smooth) && (this._horizontalSmoothScroller != null) && this._horizontalSmoothScroller.isScrolling))
            {
                this._horizontalSmoothScroller.adjustStartPosition(_local_3);
            }
        }
public function  set_scrollV(k:Float):Float        {
            this.setScrollV(k, false);
return k;
        }

        function setScrollV(k:Float, smooth:Bool)
        {
            var _local_2:WindowEvent = null;
            var _local_3 = Math.NaN;
            if (k < 0)
            {
                k = 0;
            }
            if (k > 1)
            {
                k = 1;
            }
            _local_3 = (k - this._scrollOffsetV);
            if (k != this._scrollOffsetV)
            {
                this._scrollOffsetV = k;
                this._container.y = Std.int(-this._scrollOffsetV * this.maxScrollV);
                if (_events != null)
                {
                    _local_2 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_SCROLL, this, null);
                    _events.dispatchEvent(_local_2);
                    _local_2.recycle();
                }
            }
            if (((!smooth) && (this._verticalSmoothScroller != null) && this._verticalSmoothScroller.isScrolling))
            {
                this._verticalSmoothScroller.adjustStartPosition(_local_3);
            }
        }

        
        public var scrollStepH(get,set):Float;
public function  get_scrollStepH():Float
        {
            if (this._scrollStepH >= 0)
            {
                return this._scrollStepH;
            }
            return this._horizontal ? (this._container.width / this.numListItems) : (0.1 * this._container.width);
        }

        
        public var scrollStepV(get,set):Float;
public function  get_scrollStepV():Float
        {
            if (this._scrollStepV >= 0)
            {
                return this._scrollStepV;
            }
            return this._horizontal ? (0.1 * this._container.height) : (this._container.height / this.numListItems);
        }
public function  set_scrollStepH(k:Float):Float        {
            return this._scrollStepH = k;
        }
public function  set_scrollStepV(k:Float):Float        {
            return this._scrollStepV = k;
        }

        
        public var scaleToFitItems(get,set):Bool;
public function  set_scaleToFitItems(k:Bool):Bool        {
            if (this._scaleToFitItems != k)
            {
                this._scaleToFitItems = k;
                this.updateScrollAreaRegion();
            }
return k;
        }
public function  get_scaleToFitItems():Bool
        {
            return this._scaleToFitItems;
        }

        
        public var autoArrangeItems(get,set):Bool;
public function  set_autoArrangeItems(k:Bool):Bool        {
            this._arrangeListItems = k;
            this.updateScrollAreaRegion();
return k;
        }
public function  get_autoArrangeItems():Bool
        {
            return this._arrangeListItems;
        }

        
        public var resizeOnItemUpdate(get,set):Bool;
public function  set_resizeOnItemUpdate(k:Bool):Bool        {
            this._resizeOnItemUpdate = k;
            if (this._container != null)
            {
                if (this._horizontal)
                {
                    this._container.setParamFlag(WindowParam.WINDOW_PARAM_REFLECT_HORIZONTAL_RESIZE_TO_PARENT, k);
                }
                else
                {
                    this._container.setParamFlag(WindowParam.WINDOW_PARAM_REFLECT_VERTICAL_RESIZE_TO_PARENT, k);
                }
            }
return k;
        }
public function  get_resizeOnItemUpdate():Bool
        {
            return this._resizeOnItemUpdate;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return new ItemListIterator(this);
        }

        public var firstListItem(get,never):IWindow;
public function  get_firstListItem():IWindow
        {
            return (this.numListItems > 0) ? this.getListItemAt(0) : null;
        }

        public var lastListItem(get,never):IWindow;
public function  get_lastListItem():IWindow
        {
            return (this.numListItems > 0) ? this.getListItemAt((this.numListItems - 1)) : null;
        }

        override public function  set_clipping(k:Bool):Bool        {
            super.clipping = k;
            if (this._container != null)
            {
                this._container.clipping = k;
            }
return k;
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                if (this._horizontalSmoothScroller != null)
                {
                    this._horizontalSmoothScroller.dispose();
                    this._horizontalSmoothScroller = null;
                }
                if (this._verticalSmoothScroller != null)
                {
                    this._verticalSmoothScroller.dispose();
                    this._verticalSmoothScroller = null;
                }
                this._container.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.containerEventHandler);
                this._container.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_REMOVED, this.containerEventHandler);
                this._container.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_RESIZED, this.containerEventHandler);
                this._container.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY, this.containerEventHandler);
                this._container.removeEventListener(WindowEvent.WINDOW_EVENT_CHILD_RELOCATED, this.containerEventHandler);
                super.dispose();
            }
        }

        override function cloneChildWindows(k:WindowController)
        {
            var _local_2 = 0;
            while (_local_2 < this.numListItems)
            {
                cast(k, IItemListWindow).addListItem(this.getListItemAt(_local_2).clone());
                _local_2++;
            }
        }

        public var numListItems(get,never):Int;
public function  get_numListItems():Int
        {
            return (this._container != null) ? this._container.numChildren : 0;
        }

        public function addListItem(k:IWindow):IWindow
        {
            this._updating = true;
            if (this._horizontal)
            {
                k.x = Std.int(this._scrollAreaWidth + ((this.numListItems > 0) ? this._spacing : 0));
                this._scrollAreaWidth = k.right;
                this._container.width = Std.int(this._scrollAreaWidth);
            }
            else
            {
                if (this.autoArrangeItems)
                {
                    k.y = Std.int(this._scrollAreaHeight + ((this.numListItems > 0) ? this._spacing : 0));
                    this._scrollAreaHeight = k.bottom;
                }
                else
                {
                    this._scrollAreaHeight = Math.max(this._scrollAreaHeight, k.bottom);
                }
                this._container.height = Std.int(this._scrollAreaHeight);
            }
            k = this._container.addChild(k);
            this._updating = false;
            return k;
        }

        public function addListItemAt(k:IWindow, _arg_2:UInt):IWindow
        {
            k = this._container.addChildAt(k, ASCompat.toInt(_arg_2));
            this.updateScrollAreaRegion();
            return k;
        }

        public function getListItemAt(k:UInt):IWindow
        {
            return this._container.getChildAt(ASCompat.toInt(k));
        }

        public function getListItemByID(k:UInt):IWindow
        {
            return this._container.getChildByID(ASCompat.toInt(k));
        }

        public function getListItemByName(k:String):IWindow
        {
            return this._container.getChildByName(k);
        }

        public function getListItemByTag(k:String):IWindow
        {
            return this._container.getChildByTag(k);
        }

        public function getListItemIndex(k:IWindow):Int
        {
            return this._container.getChildIndex(k);
        }

        public function removeListItem(k:IWindow):IWindow
        {
            k = this._container.removeChild(k);
            if (k != null)
            {
                this.updateScrollAreaRegion();
            }
            return k;
        }

        public function removeListItemAt(k:Int):IWindow
        {
            var _local_2= this._container.removeChildAt(k);
            return _local_2;
        }

        public function setListItemIndex(k:IWindow, _arg_2:Int)
        {
            this._container.setChildIndex(k, _arg_2);
        }

        public function swapListItems(k:IWindow, _arg_2:IWindow)
        {
            this._container.swapChildren(k, _arg_2);
            this.updateScrollAreaRegion();
        }

        public function swapListItemsAt(k:Int, _arg_2:Int)
        {
            this._container.swapChildrenAt(k, _arg_2);
            this.updateScrollAreaRegion();
        }

        public function groupListItemsWithID(k:UInt, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            return this._container.groupChildrenWithID(k, _arg_2, _arg_3);
        }

        public function groupListItemsWithTag(k:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt
        {
            return this._container.groupChildrenWithTag(k, _arg_2, _arg_3);
        }

        public function removeListItems()
        {
            this._updating = true;
            while (this.numListItems > 0)
            {
                this._container.removeChildAt(0);
            }
            this._updating = false;
            this.updateScrollAreaRegion();
        }

        public function destroyListItems()
        {
            this._updating = true;
            while (this.numListItems > 0)
            {
                this._container.removeChildAt(0).destroy();
            }
            this._updating = false;
            this.updateScrollAreaRegion();
        }

        public function arrangeListItems()
        {
            this.updateScrollAreaRegion();
        }

        override public function populate(k:Array<ASAny>)
        {
            cast(this._container, WindowController).populate(k);
            this.updateScrollAreaRegion();
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3= super.update(k, _arg_2);
            switch (_arg_2.type)
            {
                case WindowEvent.WINDOW_EVENT_RESIZE:
                    this._resizing = true;
                    
                case WindowEvent.WINDOW_EVENT_RESIZED:
                    if (!this._scaleToFitItems)
                    {
                        if (this._horizontal)
                        {
                            this._container.height = _h;
                        }
                        else
                        {
                            this._container.width = _w;
                        }
                    }
                    this.updateScrollAreaRegion();
                    this._resizing = false;
                    
                default:
                    if (Std.is(_arg_2 , WindowEvent))
                    {
                        _local_3 = this.process(_arg_2 );
                    }
            }
            return _local_3;
        }

        public function process(k:WindowEvent):Bool
        {
            var _local_2 = false;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            if (Std.is(k , WindowMouseEvent))
            {
                _local_3 = Std.int(cast(k, WindowMouseEvent).localX);
                _local_4 = Std.int(cast(k, WindowMouseEvent).localY);
                _local_5 = cast(k, WindowMouseEvent).delta;
            }
            switch (k.type)
            {
                case WindowMouseEvent.WHEEL:
                    this.scrollWithWheel(_local_5, (this._horizontal || cast(k, WindowMouseEvent).shiftKey));
                    _local_2 = (!this._isPartOfGridWindow);
                    
                case WindowMouseEvent.DOWN:
                    this._dragStartX = _local_3;
                    this._dragStartY = _local_4;
                    this._dragStartScrollH = (this._scrollOffsetH * this.maxScrollH);
                    this._dragStartScrollV = (this._scrollOffsetV * this.maxScrollV);
                    this._dragging = true;
                    _local_2 = true;
                    
                case WindowMouseEvent.MOVE:
                    if ((this._dragging && (!this._disableAutoDrag)))
                    {
                        if (this._horizontal)
                        {
                            this.scrollH = (((this._dragStartScrollH + this._dragStartX) - _local_3) / this.maxScrollH);
                        }
                        else
                        {
                            this.scrollV = (((this._dragStartScrollV + this._dragStartY) - _local_4) / this.maxScrollV);
                        }
                        _local_2 = true;
                    }
                    
                case WindowMouseEvent.UP
                   | WindowMouseEvent.UP_OUTSIDE:
                    if (this._dragging)
                    {
                        this._dragging = false;
                        _local_2 = true;
                    }
                    
            }
            return _local_2;
        }

        public function scrollWithWheel(k:Float, _arg_2:Bool):Bool
        {
            return this.getSmoothScroller(_arg_2).scrollWithWheel(k);
        }

        function getSmoothScroller(k:Bool):SmoothScroller
        {
            return k ? this.horizontalSmoothScroller : this.verticalSmoothScroller;
        }

        var horizontalSmoothScroller(get,never):SmoothScroller;
function  get_horizontalSmoothScroller():SmoothScroller
        {
            if (this._horizontalSmoothScroller == null)
            {
                this._horizontalSmoothScroller = new SmoothScroller(this.getHorizontalScrollPosition, this.setHorizontalSmoothScrollPosition, this.getHorizontalMaxScroll);
            }
            return this._horizontalSmoothScroller;
        }

        var verticalSmoothScroller(get,never):SmoothScroller;
function  get_verticalSmoothScroller():SmoothScroller
        {
            if (this._verticalSmoothScroller == null)
            {
                this._verticalSmoothScroller = new SmoothScroller(this.getVerticalScrollPosition, this.setVerticalSmoothScrollPosition, this.getVerticalMaxScroll);
            }
            return this._verticalSmoothScroller;
        }

        function getHorizontalScrollPosition():Float
        {
            return this.scrollH;
        }

        function setHorizontalSmoothScrollPosition(k:Float)
        {
            this.setScrollH(k, true);
        }

        function getHorizontalMaxScroll():Float
        {
            return this.maxScrollH;
        }

        function getVerticalScrollPosition():Float
        {
            return this.scrollV;
        }

        function setVerticalSmoothScrollPosition(k:Float)
        {
            this.setScrollV(k, true);
        }

        function getVerticalMaxScroll():Float
        {
            return this.maxScrollV;
        }

        function scrollAnimationCallback(k:Int, _arg_2:Int)
        {
            if (!disposed)
            {
                this.scrollH = (this.scrollH - (k / this._scrollAreaWidth));
                this.scrollV = (this.scrollV - (_arg_2 / this._scrollAreaHeight));
            }
        }

        function containerEventHandler(k:WindowEvent)
        {
            var _local_2:WindowEvent = null;
            switch (k.type)
            {
                case WindowEvent.WINDOW_EVENT_CHILD_REMOVED:
                    this.updateScrollAreaRegion();
                    return;
                case WindowEvent.WINDOW_EVENT_CHILD_RESIZED:
                    if (!this._resizing)
                    {
                        this.updateScrollAreaRegion();
                    }
                    return;
                case WindowEvent.WINDOW_EVENT_CHILD_VISIBILITY:
                    this.updateScrollAreaRegion();
                    return;
                case WindowEvent.WINDOW_EVENT_CHILD_RELOCATED:
                    this.updateScrollAreaRegion();
                    return;
                case WindowEvent.WINDOW_EVENT_RESIZED:
                    if (_events != null)
                    {
                        _local_2 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESIZED, this, null);
                        _events.dispatchEvent(_local_2);
                        _local_2.recycle();
                    }
                    return;
            }
        }

        function updateScrollAreaRegion()
        {
            var k:UInt = 0;
            var _local_2:IWindow = null;
            var _local_3 = 0;
            var _local_4:UInt = 0;
            if (((this._arrangeListItems && (!this._updating)) && (this._container != null)))
            {
                this._updating = true;
                k = this._container.numChildren;
                if (this._horizontal)
                {
                    this._scrollAreaWidth = 0;
                    this._scrollAreaHeight = _h;
                    _local_4 = 0;
                    while (_local_4 < k)
                    {
                        _local_2 = this._container.getChildAt(ASCompat.toInt(_local_4));
                        if (_local_2.visible)
                        {
                            _local_2.x = Std.int(this._scrollAreaWidth);
                            this._scrollAreaWidth = (this._scrollAreaWidth + (_local_2.width + this._spacing));
                            if (this._scaleToFitItems)
                            {
                                _local_3 = (_local_2.height + _local_2.y);
                                this._scrollAreaHeight = ((_local_3 > this._scrollAreaHeight) ? _local_3 : this._scrollAreaHeight);
                            }
                        }
                        _local_4++;
                    }
                    if (k > 0)
                    {
                        this._scrollAreaWidth = (this._scrollAreaWidth - this._spacing);
                    }
                }
                else
                {
                    this._scrollAreaWidth = _w;
                    this._scrollAreaHeight = 0;
                    _local_4 = 0;
                    while (_local_4 < k)
                    {
                        _local_2 = this._container.getChildAt(ASCompat.toInt(_local_4));
                        if (_local_2.visible)
                        {
                            _local_2.y = Std.int(this._scrollAreaHeight);
                            this._scrollAreaHeight = (this._scrollAreaHeight + (_local_2.height + this._spacing));
                            if (this._scaleToFitItems)
                            {
                                _local_3 = (_local_2.width + _local_2.x);
                                this._scrollAreaWidth = ((_local_3 > this._scrollAreaWidth) ? _local_3 : this._scrollAreaWidth);
                            }
                        }
                        _local_4++;
                    }
                    if (k > 0)
                    {
                        this._scrollAreaHeight = (this._scrollAreaHeight - this._spacing);
                    }
                }
                if (this._scrollOffsetH > 0)
                {
                    if (this._scrollAreaWidth <= _w)
                    {
                        this.scrollH = 0;
                    }
                    else
                    {
                        this._container.x = Std.int(-(this._scrollOffsetH * this.maxScrollH));
                    }
                }
                if (this._scrollOffsetV > 0)
                {
                    if (this._scrollAreaHeight <= _h)
                    {
                        this.scrollV = 0;
                    }
                    else
                    {
                        this._container.y = Std.int(-(this._scrollOffsetV * this.maxScrollV));
                    }
                }
                this._container.height = Std.int(this._scrollAreaHeight);
                this._container.width = Std.int(this._scrollAreaWidth);
                this._updating = false;
            }
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.SPACING, this._spacing));
            k.push(createProperty(PropertyKeys.AUTO_ARRANGE_ITEMS, this._arrangeListItems));
            k.push(createProperty(PropertyKeys.SCALE_TO_FIT_ITEMS, this._scaleToFitItems));
            k.push(createProperty(PropertyKeys.RESIZE_ON_ITEM_UPDATE, this._resizeOnItemUpdate));
            k.push(createProperty(PropertyKeys.SCROLL_STEP_HORIZONTAL, this._scrollStepH));
            k.push(createProperty(PropertyKeys.SCROLL_STEP_VERTICAL, this._scrollStepV));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.SPACING:
                        this.spacing = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.SCALE_TO_FIT_ITEMS:
                        this.scaleToFitItems = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.RESIZE_ON_ITEM_UPDATE:
                        this.resizeOnItemUpdate = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.AUTO_ARRANGE_ITEMS:
                        this._arrangeListItems = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.SCROLL_STEP_HORIZONTAL:
                        this._scrollStepH = ASCompat.asNumber(_local_2.value );
                        
                    case PropertyKeys.SCROLL_STEP_VERTICAL:
                        this._scrollStepV = ASCompat.asNumber(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }

        public function stopDragging()
        {
            this._dragging = false;
        }

        public var disableAutodrag(never,set):Bool;
public function  set_disableAutodrag(k:Bool):Bool        {
            return this._disableAutoDrag = k;
        }
    }

