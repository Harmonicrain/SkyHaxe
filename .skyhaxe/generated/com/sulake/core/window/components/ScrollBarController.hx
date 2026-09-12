package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.tablet.ITouchAwareWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowTouchEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.utils.SmoothScroller;

     class ScrollBarController extends InteractiveController implements IScrollbarWindow implements  ITouchAwareWindow 
    {
        static inline final SCROLL_STEP_SIZE:Float = 15;
        static inline final INCREMENT= "increment";
        static inline final DECREMENT= "decrement";
        static inline final SLIDER_TRACK= "slider_track";
        static inline final SLIDER_BAR= "slider_bar";

        var _offset:Float = 0;
        var _scrollStep:Float = 0.1;
        var _scrollable:IScrollableWindow;
        var _horizontal:Bool = false;
        var _targetName:String;
        var _handlingButtonEvent:Bool = false;
        var _smoothScroller:SmoothScroller;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0, _arg_12:IScrollableWindow=null)
        {
            var _local_14:IWindow = null;
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _drawable = false;
            this._scrollable = _arg_12;
            this._horizontal = (_arg_2 == WindowType.WINDOW_TYPE_SCROLLBAR_HORIZONTAL);
            this._smoothScroller = new SmoothScroller(this.getScrollOffset, this.setSmoothScrollOffset, this.getSmoothScrollAxisSize, 200, 60, true, null, SCROLL_STEP_SIZE);
            var _local_13= new Array<ASAny>();
            groupChildrenWithTag(WindowController.TAG_INTERNAL, _local_13, -1);
            if (checkNullIteratee(_local_13)) for (_tmp_ in _local_13)
            {
_local_14  = _tmp_;
                _local_14.procedure = this.scrollButtonEventProc;
            }
            this.updateLiftSizeAndPosition();
        }

        
        public var scrollH(get,set):Float;
public function  get_scrollH():Float
        {
            return this._horizontal ? this._offset : 0;
        }

        
        public var scrollV(get,set):Float;
public function  get_scrollV():Float
        {
            return this._horizontal ? 0 : this._offset;
        }

        
        public var scrollable(get,set):IScrollableWindow;
public function  get_scrollable():IScrollableWindow
        {
            return this._scrollable;
        }
public function  set_scrollH(k:Float):Float        {
            if (this._horizontal)
            {
                if (this.setScrollPosition(k))
                {
                    this.updateLiftSizeAndPosition();
                }
            }
return k;
        }
public function  set_scrollV(k:Float):Float        {
            if (!this._horizontal)
            {
                if (this.setScrollPosition(k))
                {
                    this.updateLiftSizeAndPosition();
                }
            }
return k;
        }
public function  set_scrollable(k:IScrollableWindow):IScrollableWindow        {
            if (((!(this._scrollable == null)) && (!this._scrollable.disposed)))
            {
                this._scrollable.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onScrollableResized);
                this._scrollable.removeEventListener(WindowEvent.WINDOW_EVENT_SCROLL, this.onScrollableScrolled);
            }
            this._scrollable = k;
            if (((!(this._scrollable == null)) && (!this._scrollable.disposed)))
            {
                this._scrollable.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onScrollableResized);
                this._scrollable.addEventListener(WindowEvent.WINDOW_EVENT_SCROLL, this.onScrollableScrolled);
                this.setScrollPosition(this._horizontal ? this._scrollable.scrollH : this._scrollable.scrollV, false);
                this.updateLiftSizeAndPosition();
            }
return k;
        }

        public var horizontal(get,never):Bool;
public function  get_horizontal():Bool
        {
            return this._horizontal;
        }

        public var vertical(get,never):Bool;
public function  get_vertical():Bool
        {
            return !this._horizontal;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            var _local_2:String = null;
            if (Std.is(this._scrollable , IWindow))
            {
                _local_2 = this._scrollable.name;
            }
            else
            {
                if (this._targetName != null)
                {
                    _local_2 = this._targetName;
                }
            }
            if (_local_2 == null)
            {
                k.push(getDefaultProperty(PropertyKeys.SCROLLABLE));
            }
            else
            {
                k.push(createProperty(PropertyKeys.SCROLLABLE, _local_2));
            }
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.SCROLLABLE:
                        this._targetName = ASCompat.asString(_local_2.value );
                        this._scrollable = null;
                        
                }
            }
            return super.properties = k;
        }

        var track(get,never):WindowController;
function  get_track():WindowController
        {
            return Std.downcast(findChildByName(SLIDER_TRACK) , WindowController);
        }

        var lift(get,never):WindowController;
function  get_lift():WindowController
        {
            return Std.downcast(this.track.findChildByName(SLIDER_BAR) , WindowController);
        }

        override public function dispose()
        {
            this.scrollable = null;
            if (this._smoothScroller != null)
            {
                this._smoothScroller.dispose();
                this._smoothScroller = null;
            }
            super.dispose();
        }

        override public function enable():Bool
        {
            var k:Array<ASAny> = null;
            var _local_2:UInt = 0;
            if (super.enable())
            {
                k = new Array<ASAny>();
                groupChildrenWithTag(WindowController.TAG_INTERNAL, k, -1);
                _local_2 = 0;
                while (_local_2 < (k.length : UInt))
                {
                    cast(k[ASCompat.toInt(_local_2)], IWindow).enable();
                    _local_2++;
                }
                return true;
            }
            return false;
        }

        override public function disable():Bool
        {
            var k:Array<ASAny> = null;
            var _local_2:UInt = 0;
            if (super.disable())
            {
                k = new Array<ASAny>();
                groupChildrenWithTag(WindowController.TAG_INTERNAL, k, -1);
                _local_2 = 0;
                while (_local_2 < (k.length : UInt))
                {
                    cast(k[ASCompat.toInt(_local_2)], IWindow).disable();
                    _local_2++;
                }
                return true;
            }
            return false;
        }

        function setScrollPosition(k:Float, applyToScrollable:Bool=true, smooth:Bool=false):Bool
        {
            var _local_2 = false;
            if (((this._scrollable == null) || this._scrollable.disposed))
            {
                if (!this.resolveScrollTarget())
                {
                    return false;
                }
            }
            if (k < 0)
            {
                k = 0;
            }
            if (k > 1)
            {
                k = 1;
            }
            var _local_3= k - this._offset;
            this._offset = k;
            if (applyToScrollable)
            {
                if (this._horizontal)
                {
                    _local_2 = (!(this._scrollable.scrollH == this._offset));
                    if (_local_2)
                    {
                        this._scrollable.scrollH = this._offset;
                    }
                }
                else
                {
                    _local_2 = (!(this._scrollable.scrollV == this._offset));
                    if (_local_2)
                    {
                        this._scrollable.scrollV = this._offset;
                    }
                }
            }
            if (((!smooth) && (this._smoothScroller != null) && this._smoothScroller.isScrolling))
            {
                this._smoothScroller.adjustStartPosition(_local_3);
            }
            return _local_2;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            switch (k.name)
            {
                case ScrollBarController.SLIDER_BAR:
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_CHILD_RELOCATED)
                    {
                        if (!this._handlingButtonEvent)
                        {
                            if (this._horizontal)
                            {
                                this.setScrollPosition(cast(k, DragBarController)._Str_14866);
                            }
                            else
                            {
                                this.setScrollPosition(cast(k, DragBarController)._Str_15234);
                            }
                        }
                    }
                    
            }
            var _local_3= super.update(k, _arg_2);
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_PARENT_ADDED)
            {
                if (this._scrollable == null)
                {
                    this.resolveScrollTarget();
                }
            }
            if ((k : ASAny) == (this : ASAny))
            {
                if (_arg_2.type == WindowEvent.WINDOW_EVENT_RESIZED)
                {
                    this.updateLiftSizeAndPosition();
                }
                else
                {
                    if (_arg_2.type == WindowMouseEvent.WHEEL)
                    {
                        this.scrollWithWheel(cast(_arg_2, WindowMouseEvent).delta);
                        _local_3 = true;
                    }
                }
            }
            return _local_3;
        }

        function updateLiftSizeAndPosition()
        {
            var k = Math.NaN;
            var _local_4 = 0;
            if (((this._scrollable == null) || this._scrollable.disposed))
            {
                if ((_disposed || (!this.resolveScrollTarget())))
                {
                    return;
                }
            }
            var _local_2= this.track;
            var _local_3= this.lift;
            if (_local_3 != null)
            {
                if (this._horizontal)
                {
                    k = (this._scrollable.visibleRegion.width / this._scrollable.scrollableRegion.width);
                    if (k > 1)
                    {
                        k = 1;
                    }
                    _local_4 = Std.int(k * _local_2.width);
                    _local_3.width = _local_4;
                    _local_3.x = Std.int(Math.fround((this._scrollable.scrollH * (_local_2.width - _local_4))));
                }
                else
                {
                    k = (this._scrollable.visibleRegion.height / this._scrollable.scrollableRegion.height);
                    if (k > 1)
                    {
                        k = 1;
                    }
                    _local_4 = Std.int(k * _local_2.height);
                    _local_3.height = _local_4;
                    _local_3.y = Std.int(Math.fround((this._scrollable.scrollV * (_local_2.height - _local_3.height))));
                }
            }
            if (k == 1)
            {
                this.disable();
            }
            else
            {
                this.enable();
            }
        }

        function nullEventProc__com_sulake_core_window_components_ScrollBarController/*redefined private*/(k:WindowEvent, _arg_2:IWindow)
        {
        }

        function scrollButtonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6:IWindow = null;
            var _local_3 = false;
            if (((k.type == WindowMouseEvent.DOWN) || (k.type == WindowTouchEvent.WTE_TAP)))
            {
                if (_arg_2.name == INCREMENT)
                {
                    if (this._scrollable != null)
                    {
                        this._handlingButtonEvent = true;
                        if (this._horizontal)
                        {
                            this.scrollH = (this.scrollH + (SCROLL_STEP_SIZE / this._scrollable.maxScrollH));
                        }
                        else
                        {
                            this.scrollV = (this.scrollV + (SCROLL_STEP_SIZE / this._scrollable.maxScrollV));
                        }
                        this._handlingButtonEvent = false;
                    }
                }
                else
                {
                    if (_arg_2.name == DECREMENT)
                    {
                        if (this._scrollable != null)
                        {
                            this._handlingButtonEvent = true;
                            if (this._horizontal)
                            {
                                this.scrollH = (this.scrollH - (SCROLL_STEP_SIZE / this._scrollable.maxScrollH));
                            }
                            else
                            {
                                this.scrollV = (this.scrollV - (SCROLL_STEP_SIZE / this._scrollable.maxScrollV));
                            }
                            this._handlingButtonEvent = false;
                        }
                    }
                    else
                    {
                        if (_arg_2.name == SLIDER_TRACK)
                        {
                            if (Std.is(k , WindowMouseEvent))
                            {
                                _local_4 = Std.int(cast(k, WindowMouseEvent).localX);
                                _local_5 = Std.int(cast(k, WindowMouseEvent).localY);
                            }
                            else
                            {
                                if (Std.is(k , WindowTouchEvent))
                                {
                                    _local_4 = Std.int(cast(k, WindowTouchEvent).localX);
                                    _local_5 = Std.int(cast(k, WindowTouchEvent).localY);
                                }
                            }
                            _local_6 = cast(_arg_2, WindowController).getChildByName(ScrollBarController.SLIDER_BAR);
                            if (this._horizontal)
                            {
                                if (_local_4 < _local_6.x)
                                {
                                    this.scrollH = (this.scrollH - ((this._scrollable.visibleRegion.width - SCROLL_STEP_SIZE) / this._scrollable.maxScrollH));
                                }
                                else
                                {
                                    if (_local_4 > _local_6.right)
                                    {
                                        this.scrollH = (this.scrollH + ((this._scrollable.visibleRegion.width - SCROLL_STEP_SIZE) / this._scrollable.maxScrollH));
                                    }
                                }
                            }
                            else
                            {
                                if (_local_5 < _local_6.y)
                                {
                                    this.scrollV = (this.scrollV - ((this._scrollable.visibleRegion.height - SCROLL_STEP_SIZE) / this._scrollable.maxScrollV));
                                }
                                else
                                {
                                    if (_local_5 > _local_6.bottom)
                                    {
                                        this.scrollV = (this.scrollV + ((this._scrollable.visibleRegion.height - SCROLL_STEP_SIZE) / this._scrollable.maxScrollV));
                                    }
                                }
                            }
                            _local_3 = true;
                        }
                    }
                }
            }
            if (k.type == WindowMouseEvent.WHEEL)
            {
                this.scrollWithWheel(cast(k, WindowMouseEvent).delta);
                _local_3 = true;
            }
            if (_local_3)
            {
                this.updateLiftSizeAndPosition();
            }
        }

        function resolveScrollTarget():Bool
        {
            var k:IScrollableWindow = null;
            var _local_2:UInt = 0;
            var _local_3:IScrollableWindow = null;
            var _local_4:UInt = 0;
            if (this._scrollable != null)
            {
                if (!this._scrollable.disposed)
                {
                    return true;
                }
            }
            if (this._targetName != null)
            {
                k = Std.downcast(findParentByName(this._targetName) , IScrollableWindow);
                if ((((k == null) && Std.is(_parent , IWindowContainer)) && (!Std.is(_parent , IDesktopWindow))))
                {
                    k = Std.downcast(cast(_parent, IWindowContainer).findChildByName(this._targetName) , IScrollableWindow);
                    if (k != null)
                    {
                        this.scrollable = k;
                        return true;
                    }
                }
            }
            if (Std.is(_parent , IScrollableWindow))
            {
                this.scrollable = cast(_parent, IScrollableWindow);
                return true;
            }
            if ((Std.is(_parent , IWindowContainer) && (!Std.is(_parent , IDesktopWindow))))
            {
                _local_2 = cast(_parent, IWindowContainer).numChildren;
                _local_4 = 0;
                while (_local_4 < _local_2)
                {
                    _local_3 = Std.downcast(cast(_parent, IWindowContainer).getChildAt(ASCompat.toInt(_local_4)) , IScrollableWindow);
                    if (_local_3 != null)
                    {
                        this.scrollable = _local_3;
                        return true;
                    }
                    _local_4++;
                }
            }
            return false;
        }

        function onScrollableResized(k:WindowEvent)
        {
            this.updateLiftSizeAndPosition();
        }

        function onScrollableScrolled(k:WindowEvent)
        {
            this.updateLiftSizeAndPosition();
        }

        public function scrollWithWheel(k:Int):Bool
        {
            return (this._smoothScroller != null) && this._smoothScroller.scrollWithWheel(k);
        }

        function getScrollOffset():Float
        {
            return this._offset;
        }

        function setSmoothScrollOffset(k:Float)
        {
            if (this.setScrollPosition(k, true, true))
            {
                this.updateLiftSizeAndPosition();
            }
        }

        function getSmoothScrollAxisSize():Float
        {
            if (((this._scrollable == null) || this._scrollable.disposed))
            {
                if (!this.resolveScrollTarget())
                {
                    return 0;
                }
            }
            return this._horizontal ? this._scrollable.maxScrollH : this._scrollable.maxScrollV;
        }
    }

