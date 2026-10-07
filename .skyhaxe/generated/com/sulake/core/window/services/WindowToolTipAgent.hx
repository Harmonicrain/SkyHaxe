package com.sulake.core.window.services
;
    import com.sulake.core.window.components.IToolTipWindow;
    import flash.utils.Timer;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import com.sulake.core.window.components.IInteractiveWindow;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowParam;

     class WindowToolTipAgent extends WindowMouseOperator implements IToolTipAgentService 
    {
        var _Str_3422:String;
        var _Str_3468:IToolTipWindow;
        var _Str_5194:Timer;
        var _Str_11145:Point;
        var _Str_4734:Point;
        var _Str_3681:UInt = 0;

        public function new(k:DisplayObject)
        {
            this._Str_4734 = new Point();
            this._Str_11145 = new Point(20, 20);
            this._Str_3681 = 500;
            super(k);
        }

        override public function begin(k:IWindow, _arg_2:UInt=0):IWindow
        {
            if (((k != null) && (!k.disposed)))
            {
                if (Std.is(k , IInteractiveWindow))
                {
                    this._Str_3422 = cast(k, IInteractiveWindow).toolTipCaption;
                    this._Str_3681 = cast(k, IInteractiveWindow).toolTipDelay;
                }
                else
                {
                    this._Str_3422 = k.caption;
                    this._Str_3681 = 500;
                }
                _Str_3282.x = _root.mouseX;
                _Str_3282.y = _root.mouseY;
                getMousePositionRelativeTo(k, _Str_3282, this._Str_4734);
                if (this._Str_5194 == null)
                {
                    this._Str_5194 = new Timer(this._Str_3681, 1);
                    this._Str_5194.addEventListener(TimerEvent.TIMER, (this.showToolTip : ASAny));
                }
                this._Str_5194.reset();
                this._Str_5194.start();
            }
            return super.begin(k, _arg_2);
        }

        override public function end(k:IWindow):IWindow
        {
            if (this._Str_5194 != null)
            {
                this._Str_5194.stop();
                this._Str_5194.removeEventListener(TimerEvent.TIMER, (this.showToolTip : ASAny));
                this._Str_5194 = null;
            }
            this.hideToolTip();
            return super.end(k);
        }

        override public function operate(k:Int, _arg_2:Int)
        {
            if (((window != null) && (!window.disposed)))
            {
                _Str_3282.x = k;
                _Str_3282.y = _arg_2;
                getMousePositionRelativeTo(window, _Str_3282, this._Str_4734);
                if (((!(this._Str_3468 == null)) && (!this._Str_3468.disposed)))
                {
                    this._Str_3468.x = Std.int(k + this._Str_11145.x);
                    this._Str_3468.y = Std.int(_arg_2 + this._Str_11145.y);
                }
            }
        }

        function showToolTip(k:TimerEvent)
        {
            var _local_2:Point = null;
            if (this._Str_5194 != null)
            {
                this._Str_5194.reset();
            }
            if (((window != null) && (!window.disposed)))
            {
                if (Std.is(window , IInteractiveWindow))
                {
                    this._Str_3422 = cast(window, IInteractiveWindow).toolTipCaption;
                }
                else
                {
                    this._Str_3422 = window.caption;
                }
                if (((this._Str_3468 == null) || this._Str_3468.disposed))
                {
                    this._Str_3468 = Std.downcast(window.context.create((window.name + "::ToolTip"), this._Str_3422, WindowType.WINDOW_TYPE_TOOLTIP, window.style, (ASCompat.toInt(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT )| ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), null, null, null, 0, null, null) , IToolTipWindow);
                }
                _local_2 = new Point();
                window.getGlobalPosition(_local_2);
                this._Str_3468.x = Std.int((_local_2.x + this._Str_4734.x) + this._Str_11145.x);
                this._Str_3468.y = Std.int((_local_2.y + this._Str_4734.y) + this._Str_11145.y);
                this._Str_3468.visible = (this._Str_3468.caption.length > 0);
            }
        }

        function hideToolTip()
        {
            if (((!(this._Str_3468 == null)) && (!this._Str_3468.disposed)))
            {
                this._Str_3468.destroy();
                this._Str_3468 = null;
            }
        }

        public function updateCaption(k:IWindow)
        {
            var _local_2:String = null;
            if (((((k == null) || k.disposed) || (this._Str_3468 == null)) || this._Str_3468.disposed))
            {
                return;
            }
            if (Std.is(k , IInteractiveWindow))
            {
                _local_2 = cast(k, IInteractiveWindow).toolTipCaption;
            }
            else
            {
                _local_2 = k.caption;
            }
            if (_local_2 != this._Str_3422)
            {
                this._Str_3422 = _local_2;
                if (((_local_2 == null) || (_local_2.length == 0)))
                {
                    this._Str_3468.visible = false;
                }
                else
                {
                    this._Str_3468.caption = _local_2;
                    this._Str_3468.visible = true;
                }
            }
        }
    }

