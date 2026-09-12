package com.sulake.core.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.graphics.IWindowRenderer;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.IInputEventTracker;
    import com.sulake.core.window._enum.MouseCursorType;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.events.MouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.components.IInteractiveWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.RegionController;
    import com.sulake.core.window._enum.*;

     class MouseEventProcessor implements IEventProcessor implements  IDisposable 
    {
        static var _Str_4716:Array<ASAny>;
        static var _Str_4392:Array<ASAny>;
        static var _Str_5267:Point = new Point();

        var location:Point;
        var _Str_3558:WindowController;
        var _Str_3275:WindowController;
        var _renderer:IWindowRenderer;
        var _desktopWindow:IDesktopWindow;
        var _Str_8811:Vector<IInputEventTracker>;
        var _disposed:Bool = false;

        public function new()
        {
            this.location = new Point();
            if (_Str_4716 == null)
            {
                _Str_4716 = new Array<ASAny>();
                _Str_4716[0] = MouseCursorType.ARROW_LINK;
                _Str_4716[1] = MouseCursorType.DEFAULT;
                _Str_4716[2] = MouseCursorType.ARROW_LINK;
                _Str_4716[3] = MouseCursorType.ARROW_LINK;
                _Str_4716[4] = MouseCursorType.ARROW_LINK;
                _Str_4716[5] = MouseCursorType.DEFAULT;
                _Str_4716[6] = MouseCursorType.ARROW_LINK;
            }
            if (_Str_4392 == null)
            {
                _Str_4392 = new Array<ASAny>();
                _Str_4392[0] = WindowState.ACTIVE;
                _Str_4392[1] = WindowState.FOCUSED;
                _Str_4392[2] = WindowState.HOVERING;
                _Str_4392[3] = WindowState.LOCKED;
                _Str_4392[4] = WindowState.SELECTED;
                _Str_4392[5] = WindowState.PRESSED;
                _Str_4392[6] = WindowState.DISABLED;
            }
        }

        public static function _Str_26019(k:UInt, _arg_2:UInt)
        {
            var _local_3= _Str_4392.indexOf(k);
            if (_local_3 > -1)
            {
                _Str_4716[_local_3] = _arg_2;
            }
        }

        public static function getMouseCursorByState(k:UInt):UInt
        {
            var _local_2:UInt = _Str_4392.length;
            while (_local_2-- > 0)
            {
                if ((ASCompat.toInt(k )& ASCompat.toInt(_Str_4392[ASCompat.toInt(_local_2)])) > 0)
                {
                    return ASCompat.toUInt(_Str_4716[ASCompat.toInt(_local_2)]);
                }
            }
            return MouseCursorType.DEFAULT;
        }

        static function _Str_9426(k:MouseEvent, _arg_2:IWindow, _arg_3:IWindow):WindowMouseEvent
        {
            var _local_4:String = null;
            var _local_5:Point = null;
            var _local_6 = false;
            _local_5 = _arg_2.desktop.getDisplayObject().globalToLocal(new Point(k.stageX, k.stageY));
            // The window system compares stageX/stageY against window coordinates from
            // getGlobalPosition/hitTestGlobalPoint, which are desktop-space. Reporting the raw Flash
            // stage point only agrees with those while the desktop is unscaled and unshifted; once the
            // mobile layer has a scale or a safe-area offset it is wrong by exactly that transform.
            var _local_7= _local_5.clone();
            _arg_2.convertPointFromGlobalToLocalSpace(_local_5);
            switch (k.type)
            {
                case MouseEvent.MOUSE_MOVE:
                    _local_4 = WindowMouseEvent.MOVE;
                    
                case MouseEvent.MOUSE_OVER:
                    _local_4 = WindowMouseEvent.OVER;
                    
                case MouseEvent.MOUSE_OUT:
                    _local_4 = WindowMouseEvent.OUT;
                    
                case MouseEvent.ROLL_OUT:
                    _local_4 = WindowMouseEvent.ROLL_OUT;
                    
                case MouseEvent.ROLL_OVER:
                    _local_4 = WindowMouseEvent.ROLL_OVER;
                    
                case MouseEvent.CLICK:
                    _local_4 = WindowMouseEvent.CLICK;
                    
                case MouseEvent.DOUBLE_CLICK:
                    _local_4 = WindowMouseEvent.DOUBLE_CLICK;
                    
                case MouseEvent.MOUSE_DOWN:
                    _local_4 = WindowMouseEvent.DOWN;
                    
                case MouseEvent.MOUSE_UP:
                    _local_6 = ((((_local_5.x > -1) && (_local_5.y > -1)) && (_local_5.x < _arg_2.width)) && (_local_5.y < _arg_2.height));
                    _local_4 = (_local_6 ? WindowMouseEvent.UP : WindowMouseEvent.UP_OUTSIDE);
                    
                case MouseEvent.MOUSE_WHEEL:
                    _local_4 = WindowMouseEvent.WHEEL;
                    
                default:
                    _local_4 = WindowEvent.UNKNOWN;
            }
            return WindowMouseEvent.allocate(_local_4, _arg_2, _arg_3, _local_5.x, _local_5.y, _local_7.x, _local_7.y, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown, k.delta);
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._disposed = true;
            }
        }

        public function process(state:EventProcessorState, eventQueue:IEventQueue)
        {
            var event:MouseEvent = null;
            var index = 0;
            var child:WindowController = null;
            var array:Array<ASAny> = null;
            var tempWindowEvent:WindowEvent = null;
            var window:IWindow = null;
            var temp:IWindow = null;
            if (eventQueue.length == 0)
            {
                return;
            }
            this._desktopWindow = state.desktop;
            this._Str_3275 = Std.downcast(state.hoverWindow , WindowController);
            this._Str_3558 = Std.downcast(state.lastClickTarget , WindowController);
            this._renderer = state.renderer;
            this._Str_8811 = state.eventTrackers;
            eventQueue.begin();
            this.location.x = -1;
            this.location.y = -1;
            var mouseCursorType= ASCompat.toInt(MouseCursorType.DEFAULT);
            while (true)
            {
                event = Std.downcast(eventQueue.next() , MouseEvent);
                if (event == null) break;
                if (((!(event.stageX == this.location.x)) || (!(event.stageY == this.location.y))))
                {
                    this.location = this._desktopWindow.getDisplayObject().globalToLocal(new Point(event.stageX, event.stageY));
                    array = new Array<ASAny>();
                    this._desktopWindow.groupParameterFilteredChildrenUnderPoint(this.location, array, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR);
                }
                index = ((array != null) ? array.length : 0);
                if (index == 0)
                {
                    switch (event.type)
                    {
                        case MouseEvent.MOUSE_MOVE:
                            if (((!((this._Str_3275 : ASAny) == (this._desktopWindow : ASAny))) && (!this._Str_3275.disposed)))
                            {
                                this._Str_3275.getGlobalPosition(_Str_5267);
                                tempWindowEvent = WindowMouseEvent.allocate(WindowMouseEvent.OUT, this._Str_3275, null, (this.location.x - _Str_5267.x), (this.location.y - _Str_5267.y), this.location.x, this.location.y, event.altKey, event.ctrlKey, event.shiftKey, event.buttonDown, event.delta);
                                this._Str_3275.update(this._Str_3275, tempWindowEvent);
                                this._Str_3275 = cast(this._desktopWindow, WindowController);
                                tempWindowEvent.recycle();
                            }
                            
                        case MouseEvent.MOUSE_DOWN:
                            window = this._desktopWindow.getActiveWindow();
                            if (window != null)
                            {
                                window.deactivate();
                            }
                            
                        case MouseEvent.MOUSE_UP:
                            if (this._Str_3558 != null)
                            {
                                array.push(this._Str_3558);
                                index = (index + 1);
                            }
                            
                    }
                }
                while (--index > -1)
                {
                    child = this._Str_16513(cast(array[index], WindowController), event);
                    if (((!(child == null)) && child.visible))
                    {
                        if (event.type == MouseEvent.MOUSE_MOVE)
                        {
                            if (child != this._Str_3275)
                            {
                                if (!this._Str_3275.disposed)
                                {
                                    this._Str_3275.getGlobalPosition(_Str_5267);
                                    tempWindowEvent = WindowMouseEvent.allocate(WindowMouseEvent.OUT, this._Str_3275, child, (this.location.x - _Str_5267.x), (this.location.y - _Str_5267.y), this.location.x, this.location.y, event.altKey, event.ctrlKey, event.shiftKey, event.buttonDown, event.delta);
                                    this._Str_3275.update(this._Str_3275, tempWindowEvent);
                                    tempWindowEvent.recycle();
                                }
                                if (!child.disposed)
                                {
                                    child.getGlobalPosition(_Str_5267);
                                    tempWindowEvent = WindowMouseEvent.allocate(WindowMouseEvent.OVER, child, null, (this.location.x - _Str_5267.x), (this.location.y - _Str_5267.y), this.location.x, this.location.y, event.altKey, event.ctrlKey, event.shiftKey, event.buttonDown, event.delta);
                                    child.update(child, tempWindowEvent);
                                    tempWindowEvent.recycle();
                                }
                                if (!child.disposed)
                                {
                                    this._Str_3275 = child;
                                }
                            }
                        }
                        temp = child.parent;
                        while (((temp != null) && (!temp.disposed)))
                        {
                            if (Std.is(temp , IInputProcessorRoot))
                            {
                                tempWindowEvent = _Str_9426(event, temp, child);
                                cast(temp, IInputProcessorRoot).process(tempWindowEvent);
                                tempWindowEvent.recycle();
                                break;
                            }
                            temp = temp.parent;
                        }
                        if (Std.is(this._Str_3275 , IInteractiveWindow))
                        {
                            try
                            {
                                mouseCursorType = ASCompat.toInt(cast(this._Str_3275, IInteractiveWindow).getMouseCursorByState(this._Str_3275.state));
                                if ((mouseCursorType : UInt) == MouseCursorType.DEFAULT)
                                {
                                    mouseCursorType = ASCompat.toInt(getMouseCursorByState(this._Str_3275.state));
                                }
                            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                             {
                                mouseCursorType = ASCompat.toInt(MouseCursorType.DEFAULT);
                            }
 }                        }
                        if ((child : ASAny) != (this._desktopWindow : ASAny))
                        {
                            event.stopPropagation();
                            eventQueue.remove();
                        }
                        break;
                    }
                }
            }
            eventQueue.end();
            MouseCursorControl.type = mouseCursorType;
            state.desktop = this._desktopWindow;
            state.hoverWindow = this._Str_3275;
            state.lastClickTarget = this._Str_3558;
            state.renderer = this._renderer;
            state.eventTrackers = this._Str_8811;
        }

        function _Str_16513(k:WindowController, _arg_2:MouseEvent, _arg_3:Bool=false):WindowController
        {
            var _local_9:IInputEventTracker = null;
            var _local_10:BitmapData = null;
            if (k.disposed)
            {
                return null;
            }
            if (((k.testStateFlag(WindowState.DISABLED) && (_arg_2.type == MouseEvent.MOUSE_MOVE)) && Std.is(k , RegionController)))
            {
                return k;
            }
            if (k.testStateFlag(WindowState.DISABLED))
            {
                return null;
            }
            var _local_4 = false;
            var _local_5= k.desktop.getDisplayObject().globalToLocal(new Point(_arg_2.stageX, _arg_2.stageY));
            k.convertPointFromGlobalToLocalSpace(_local_5);
            if (_arg_2.type == MouseEvent.MOUSE_UP)
            {
                if (k != this._Str_3558)
                {
                    if (((this._Str_3558 != null) && (!this._Str_3558.disposed)))
                    {
                        this._Str_3558.update(this._Str_3558, _Str_9426(new MouseEvent(MouseEvent.MOUSE_UP, false, true, _arg_2.localX, _arg_2.localY, null, _arg_2.ctrlKey, _arg_2.altKey, _arg_2.shiftKey, _arg_2.buttonDown, _arg_2.delta), this._Str_3558, k));
                        this._Str_3558 = null;
                        if (k.disposed)
                        {
                            return null;
                        }
                    }
                }
                else
                {
                    _local_4 = (!k.hitTestLocalPoint(_local_5));
                }
            }
            if (!_local_4)
            {
                _local_10 = this._renderer._Str_19855(k);
                if (!k.validateLocalPointIntersection(_local_5, _local_10))
                {
                    return null;
                }
            }
            if (k.testParamFlag(WindowParam.WINDOW_PARAM_ROUTE_INPUT_EVENTS_TO_PARENT))
            {
                if (k.parent != null)
                {
                    return this._Str_16513(cast(k.parent, WindowController), _arg_2);
                }
            }
            if (!_arg_3)
            {
                switch (_arg_2.type)
                {
                    case MouseEvent.MOUSE_DOWN:
                        this._Str_3558 = k;
                        
                    case MouseEvent.CLICK:
                        if (this._Str_3558 != k)
                        {
                            return null;
                        }
                        this._Str_3558 = null;
                        
                    case MouseEvent.DOUBLE_CLICK:
                        if (this._Str_3558 != k)
                        {
                            return null;
                        }
                        this._Str_3558 = null;
                        
                }
            }
            var _local_6:IWindow = null;
            var _local_7= _Str_9426(_arg_2, k, _local_6);
            var _local_8= k.update(k, _local_7);
            final _iter_ = this._Str_8811; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_9  = _tmp_;
                _local_9.eventReceived(_local_7, k);
            }
            _local_7.recycle();
            if (((!_local_8) && (!_arg_3)))
            {
                if (k.parent != null)
                {
                    return this._Str_16513(cast(k.parent, WindowController), _arg_2);
                }
            }
            return k;
        }
    }

