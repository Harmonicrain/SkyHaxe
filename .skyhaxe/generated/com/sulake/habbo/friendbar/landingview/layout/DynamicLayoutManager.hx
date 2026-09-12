package com.sulake.habbo.friendbar.landingview.layout
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Rectangle;

     class DynamicLayoutManager implements IDisposable 
    {
        public static inline final PLACEHOLDER_DYNAMIC_WIDGET_SLOTS= "placeholder_dynamic_widget_slots";
        public static inline final _Str_16813= 230;
        static inline final _Str_5206= 5;
        static inline final _Str_16031= 6;
        static inline final _Str_16857= 360;

        var _layout:WidgetContainerLayout;
        var _fromTop:IItemListWindow;
        var _center:IItemListWindow;
        var _leftPane:IItemListWindow;
        var _centerContainer:IWindowContainer;
        var _rightPane:IItemListWindow;
        var _rightContainer:IWindowContainer;
        var _slots:Vector<IWindowContainer>;
        var _leftDownSlotRoot:IItemListWindow;
        var _rightDownSlotRoot:IItemListWindow;
        var _scrollExtraSpace:IWindowContainer;
        var _separatorTemplate:IWindow;
        var _fromTopScrollbar:IScrollbarWindow;
        var _window:IWindowContainer;
        var _ignoreBottomRightSlot:Bool = false;
        var _commonWidgetSettings:CommonWidgetSettings;
        var _minWhiteSpaceVerticalMiddle:Int = 10;
        var _maxWhiteSpaceVerticalMiddle:Int = 50;
        var _minWhiteSpaceVerticalTop:Int = 10;
        var _maxWhiteSpaceVerticalTop:Int = 80;
        var _minWhiteSpaceHorizontal:Int = 10;
        var _maxWhiteSpaceHorizontal:Int = 60;
        var _topItemListInitialHeight:Int = -1;
        var _topItemListInitialWidth:Int = -1;
        var _initialized:Bool = false;
        var _currentlyResizingWindow:IWindow = null;

        public function new(k:WidgetContainerLayout, _arg_2:CommonWidgetSettings)
        {
            this._slots = new Vector<IWindowContainer>(_Str_5206);
            this._layout = k;
            this._commonWidgetSettings = _arg_2;
            this._window = cast(this._layout.landingView.getXmlWindow("dynamic_widget_grid"), IWindowContainer);
            var _local_3= this._layout.window.findChildByName(PLACEHOLDER_DYNAMIC_WIDGET_SLOTS);
            var _local_4= cast(_local_3.parent, IWindowContainer);
            _local_4.addChildAt(this._window, _local_4.getChildIndex(_local_3));
            _local_4.removeChild(_local_3);
            this._fromTop = cast(this._window.findChildByName("widgetlist_fromtop"), IItemListWindow);
            this._centerContainer = cast(this._window.findChildByName("center_slots_container"), IWindowContainer);
            this._center = cast(this._window.findChildByName("widget_slots_center_scrollable"), IItemListWindow);
            this._leftPane = cast(this._window.findChildByName("widget_slots_center_left"), IItemListWindow);
            this._rightPane = cast(this._window.findChildByName("widget_slots_center_right"), IItemListWindow);
            this._rightContainer = cast(this._window.findChildByName("widget_slots_right"), IWindowContainer);
            this._leftDownSlotRoot = cast(this._window.findChildByName("widget_slot_4_root"), IItemListWindow);
            this._rightDownSlotRoot = cast(this._window.findChildByName("widget_slot_5_root"), IItemListWindow);
            this._separatorTemplate = this._layout.landingView.getXmlWindow("dynamic_widget_grid_separator");
            var _local_5 = 0;
            while (_local_5 < 6)
            {
                this._slots[_local_5] = cast(this._window.findChildByName(("widget_slot_" + Std.string(_local_5 + 1))), IWindowContainer);
                if (this._slots[_local_5] != null)
                {
                    this._slots[_local_5].addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_21981);
                }
                _local_5++;
            }
            this._fromTopScrollbar = cast(this._window.findChildByName("center_container_scrollbar"), IScrollbarWindow);
            this._scrollExtraSpace = cast(this._window.findChildByName("scroll_extra_space_container"), IWindowContainer);
            var _local_6= this._layout.landingView.dynamicLayoutLeftPaneWidth;
            var _local_7= this._layout.landingView.dynamicLayoutRightPaneWidth;
            this._leftPane.width = _local_6;
            this._leftPane.limits.maxWidth = _local_6;
            this._leftDownSlotRoot.width = _local_6;
            this._rightPane.width = _local_7;
            this._rightContainer.width = _local_7;
            this._rightContainer.limits.maxWidth = _local_7;
            this._rightDownSlotRoot.width = _local_7;
            this._center.arrangeListItems();
        }

        public function dispose()
        {
            var k = 0;
            if (!this.disposed)
            {
                k = 0;
                while (k < 6)
                {
                    if (this._slots[k] != null)
                    {
                        this._slots[k].dispose();
                    }
                    this._slots[k] = null;
                    k++;
                }
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
                this._layout = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._layout == null;
        }

        public function _Str_23980(k:Int):IWindowContainer
        {
            return this._slots[k];
        }

        public function _Str_20363(k:Int, _arg_2:String)
        {
            var _local_3:IItemListWindow = null;
            var _local_4:ITextWindow = null;
            switch (k)
            {
                case 4:
                    _local_3 = this._leftDownSlotRoot;
                    
                case 5:
                    _local_3 = this._rightDownSlotRoot;
                    
                default:
                    _local_3 = null;
            }
            if (_local_3 != null)
            {
                if (_local_3.numListItems < 2)
                {
                    _local_3.addListItemAt(this._separatorTemplate.clone(), 0);
                }
                _local_4 = cast(cast(_local_3.getListItemAt(0), IItemListWindow).getListItemByName("separator_title"), ITextWindow);
                _local_4.caption = (("${" + _arg_2) + "}");
                if (this._commonWidgetSettings != null)
                {
                    if (this._commonWidgetSettings.isTextColorSet)
                    {
                        _local_4.textColor = this._commonWidgetSettings.textColor;
                    }
                    if (this._commonWidgetSettings.isEtchingColorSet)
                    {
                        _local_4.etchingColor = this._commonWidgetSettings.etchingColor;
                    }
                    if (this._commonWidgetSettings.isEtchingPositionSet)
                    {
                        _local_4.etchingPosition = this._commonWidgetSettings.etchingPosition;
                    }
                }
            }
        }

        function _Str_5410(k:Int):Bool
        {
            return this._slots[k].numChildren > 0;
        }

        public function _Str_24842(k:Int, _arg_2:Int)
        {
            this._fromTop.height = Std.int(Math.min(_arg_2, this._Str_19625));
            this._fromTop.height = Std.int(Math.max(_Str_16857, this._fromTop.height));
            this._fromTop.width = Std.int(Math.min(k, this._Str_19568));
            this._Str_20032();
        }

        public var _Str_22592(never,set):Int;
public function  set__Str_22592(k:Int):Int        {
            var _local_2= this._layout.window.width;
            k = Std.int(Math.min(k, _local_2) - this._window.x);
            this._fromTopScrollbar.x = (k - this._fromTopScrollbar.width);
return k;
        }

        public var _Str_19625(get,never):Int;
public function  get__Str_19625():Int
        {
            if (this._topItemListInitialHeight == -1)
            {
                this._topItemListInitialHeight = this._fromTop.height;
            }
            return this._topItemListInitialHeight;
        }

        public var _Str_19568(get,never):Int;
public function  get__Str_19568():Int
        {
            if (this._topItemListInitialWidth == -1)
            {
                this._topItemListInitialWidth = this._fromTop.width;
            }
            return this._topItemListInitialWidth;
        }

        function _Str_20032()
        {
            var k = 0;
            this._Str_24621();
            this._Str_23270();
            this._Str_25588();
            this._Str_23636();
            this._Str_23499((this._Str_17991 - this._fromTop.height));
            this._Str_21981();
            this._Str_25872();
            this._Str_24686();
            if (!this._initialized)
            {
                k = 0;
                while (k < 6)
                {
                    if (this._slots[k] != null)
                    {
                        this._slots[k].addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.updateLayout);
                    }
                    k++;
                }
            }
            this._initialized = true;
            this._currentlyResizingWindow = null;
        }

        function updateLayout(k:WindowEvent=null)
        {
            if (this._currentlyResizingWindow == null)
            {
                this._currentlyResizingWindow = k.window;
                this._Str_20032();
            }
        }

        function _Str_24621()
        {
            if (!this._Str_5410(0))
            {
                this._slots[0].height = 0;
            }
            var k= 1;
            while (k <= 4)
            {
                if (!this._Str_5410(k))
                {
                    this._slots[k].height = 1;
                }
                k++;
            }
        }

        function _Str_25588()
        {
            var k = 0;
            if ((this._Str_5410(3) || this._Str_5410(4)))
            {
                k = Std.int(Math.max(this._slots[3].height, this._slots[4].height));
                this._slots[3].height = k;
                this._slots[4].height = k;
                if (this._Str_5410(3))
                {
                    this._slots[3].getChildAt(0).y = 0;
                    this._slots[3].width = this._layout.landingView.dynamicLayoutLeftPaneWidth;
                }
                if (this._Str_5410(4))
                {
                    this._slots[4].getChildAt(0).y = 0;
                    this._slots[4].width = this._layout.landingView.dynamicLayoutRightPaneWidth;
                }
            }
        }

        function _Str_23270():Int
        {
            var k = 0;
            if ((this._Str_5410(1) || this._Str_5410(2)))
            {
                if (!this._ignoreBottomRightSlot)
                {
                    k = Std.int(Math.max(this._slots[1].height, this._slots[2].height));
                    this._slots[1].height = k;
                    this._slots[2].height = k;
                }
                if (this._Str_5410(1))
                {
                    this._slots[1].getChildAt(0).y = 0;
                    this._slots[1].width = this._layout.landingView.dynamicLayoutLeftPaneWidth;
                }
                if (this._Str_5410(2))
                {
                    this._slots[2].getChildAt(0).y = 0;
                    this._slots[2].width = this._layout.landingView.dynamicLayoutRightPaneWidth;
                }
            }
            return k;
        }

        function _Str_24686()
        {
            var k= (this._topItemListInitialWidth - this._fromTop.width);
            if (k > (this._maxWhiteSpaceHorizontal - this._minWhiteSpaceHorizontal))
            {
                this._center.spacing = this._minWhiteSpaceHorizontal;
            }
            else
            {
                this._center.spacing = Std.int(Math.min(this._maxWhiteSpaceHorizontal, (this._maxWhiteSpaceHorizontal - k)));
            }
        }

        function _Str_23499(k:Int)
        {
            var _local_2= (this._maxWhiteSpaceVerticalMiddle - this._minWhiteSpaceVerticalMiddle);
            var _local_3= (this._maxWhiteSpaceVerticalTop - this._minWhiteSpaceVerticalTop);
            k = (k + (this._minWhiteSpaceVerticalMiddle + this._minWhiteSpaceVerticalTop));
            if (k <= 0)
            {
                this._fromTop.spacing = this._minWhiteSpaceVerticalTop;
                this._leftPane.spacing = this._maxWhiteSpaceVerticalMiddle;
                this._rightPane.spacing = this._maxWhiteSpaceVerticalMiddle;
            }
            else
            {
                if (k < _local_2)
                {
                    this._fromTop.spacing = this._minWhiteSpaceVerticalTop;
                    this._leftPane.spacing = (this._maxWhiteSpaceVerticalMiddle - k);
                    this._rightPane.spacing = (this._maxWhiteSpaceVerticalMiddle - k);
                }
                else
                {
                    if (k < (_local_2 + _local_3))
                    {
                        this._fromTop.spacing = this._minWhiteSpaceVerticalTop;
                        this._leftPane.spacing = this._minWhiteSpaceVerticalMiddle;
                        this._rightPane.spacing = this._minWhiteSpaceVerticalMiddle;
                    }
                    else
                    {
                        this._fromTop.spacing = this._minWhiteSpaceVerticalTop;
                        this._leftPane.spacing = this._minWhiteSpaceVerticalMiddle;
                        this._rightPane.spacing = this._minWhiteSpaceVerticalMiddle;
                    }
                }
            }
        }

        function _Str_25872()
        {
            this._fromTop.invalidate();
            if (this._fromTop.height < (this._Str_17991 - _Str_16031))
            {
                this._fromTopScrollbar.y = this._fromTop.y;
                this._fromTopScrollbar.height = this._fromTop.height;
                this._fromTopScrollbar.visible = true;
                this._fromTopScrollbar.scrollV = 0;
                this._scrollExtraSpace.y = this._Str_17991;
                this._scrollExtraSpace.height = 25;
                this._layout.landingView.toolbarExtensionExtraMargin = true;
            }
            else
            {
                this._scrollExtraSpace.y = 0;
                this._scrollExtraSpace.height = 1;
                this._layout.landingView.toolbarExtensionExtraMargin = false;
            }
        }

        function _Str_23636()
        {
            this._center.spacing = this._maxWhiteSpaceHorizontal;
            this._leftPane.spacing = this._maxWhiteSpaceVerticalMiddle;
            this._rightPane.spacing = this._maxWhiteSpaceVerticalMiddle;
            this._fromTop.spacing = this._maxWhiteSpaceVerticalTop;
            this._fromTopScrollbar.visible = false;
            this._leftPane.invalidate();
            this._rightPane.invalidate();
            this._center.invalidate();
            this._fromTop.invalidate();
            this._centerContainer.invalidate();
        }

        var _Str_17991(get,never):Int;
function  get__Str_17991():Int
        {
            var _local_3 = 0;
            var k = 0;
            var _local_2 = 0;
            while (_local_2 < this._fromTop.numListItems)
            {
                _local_3 = this._fromTop.getListItemAt(_local_2).height;
                k = (k + _local_3);
                if (_local_2 > 0)
                {
                    k = (k + this._fromTop.spacing);
                }
                _local_2++;
            }
            return k;
        }

        function _Str_21981(k:WindowEvent=null)
        {
            if (((!(k == null)) && (!this._initialized)))
            {
                return;
            }
            this._leftPane.invalidate();
            this._rightPane.invalidate();
            this._center.height = Std.int(Math.max(this._leftPane.height, this._rightPane.height));
            this._centerContainer.height = Std.int(Math.max(this._leftPane.height, this._rightPane.height));
        }

        public var _Str_24583(never,set):Bool;
public function  set__Str_24583(k:Bool):Bool        {
            return this._ignoreBottomRightSlot = k;
        }

        function _Str_25885()
        {
            Logger.log(["***** Final positions *****"]);
            var k= new Rectangle();
            this._window.getGlobalRectangle(k);
            Logger.log([("Window rect\t\t\t\t\t\t: " + k)]);
            this._fromTop.getGlobalRectangle(k);
            Logger.log([("All items list rect\t\t\t\t: " + k)]);
            this._centerContainer.getGlobalRectangle(k);
            Logger.log([("Center container itemlist rect\t: " + k)]);
            this._center.getGlobalRectangle(k);
            Logger.log([("Center itemlist rect\t\t\t: " + k)]);
            this._leftPane.getGlobalRectangle(k);
            Logger.log([("Left pane itemlist rect\t\t\t: " + k)]);
            this._rightPane.getGlobalRectangle(k);
            Logger.log([("Right pane itemlist rect\t\t: " + k)]);
            this._rightContainer.getGlobalRectangle(k);
            Logger.log([("Right pane container rect\t\t: " + k)]);
            var _local_2 = 0;
            while (_local_2 < 5)
            {
                this._slots[_local_2].getGlobalRectangle(k);
                Logger.log([((("Slot " + Std.string(_local_2)) + " rect\t\t\t    : ") + k)]);
                _local_2++;
            }
        }
    }

