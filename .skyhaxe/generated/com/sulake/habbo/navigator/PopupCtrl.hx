package com.sulake.habbo.navigator
;
    import flash.utils.Timer;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.TimerEvent;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Point;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class PopupCtrl 
    {
        var _navigator:HabboNavigator;
        var _xmlFileName:String;
        var _popupIndentRight:Int = 0;
        var _popupIndentLeft:Int = 0;
        var _displayTimer:Timer;
        var _hideTimer:Timer;
        var _popup:IWindowContainer;

        public function new(k:HabboNavigator, _arg_2:Int, _arg_3:Int, _arg_4:String)
        {
            this._displayTimer = new Timer(500, 1);
            this._hideTimer = new Timer(100, 1);
            this._navigator = k;
            this._xmlFileName = _arg_4;
            this._popupIndentRight = _arg_2;
            this._popupIndentLeft = _arg_3;
            this._displayTimer.addEventListener(TimerEvent.TIMER, (this._Str_10545 : ASAny));
            this._hideTimer.addEventListener(TimerEvent.TIMER, (this._Str_6823 : ASAny));
        }

        public var navigator(get,never):HabboNavigator;
public function  get_navigator():HabboNavigator
        {
            return this._navigator;
        }

        public function dispose()
        {
            this._navigator = null;
            if (this._displayTimer != null)
            {
                this._displayTimer.removeEventListener(TimerEvent.TIMER, (this._Str_10545 : ASAny));
                this._displayTimer.reset();
                this._displayTimer = null;
            }
            if (this._hideTimer != null)
            {
                this._hideTimer.removeEventListener(TimerEvent.TIMER, (this._Str_6823 : ASAny));
                this._hideTimer.reset();
                this._hideTimer = null;
            }
        }

        public function _Str_8168(k:IWindow)
        {
            if (this._popup == null)
            {
                this._popup = cast(this._navigator.getXmlWindow(this._xmlFileName), IWindowContainer);
                this._popup.visible = false;
                this._popup.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
                this._popup.procedure = this._Str_22278;
            }
            Util.hideChildren(this._popup);
            this.refreshContent(this._popup);
            this._popup.height = (Util.getLowestPoint(this._popup) + 5);
            var _local_2= new Point();
            k.getGlobalPosition(_local_2);
            this._popup.x = Std.int((_local_2.x + this._popupIndentRight) + k.width);
            this._popup.y = Std.int((_local_2.y - (this._popup.height * 0.5)) + (k.height * 0.5));
            var _local_3= new Point();
            this._popup.getGlobalPosition(_local_3);
            if ((_local_3.x + this._popup.width) > this._popup.desktop.width)
            {
                this._popup.x = Std.int((-this._popup.width + _local_2.x) + this._popupIndentLeft);
                this._Str_21836(this._popup, false);
            }
            else
            {
                this._Str_21836(this._popup, true);
            }
            if (!this._popup.visible)
            {
                this._displayTimer.reset();
                this._displayTimer.start();
            }
            this._hideTimer.reset();
            this._popup.activate();
        }

        public function _Str_17240()
        {
            this._hideTimer.reset();
            this._displayTimer.reset();
            this._hideTimer.start();
        }

        function _Str_21836(k:IWindowContainer, _arg_2:Bool)
        {
            this._Str_20045(k, true, _arg_2);
            this._Str_20045(k, false, (!_arg_2));
        }

        function _Str_20045(k:IWindowContainer, _arg_2:Bool, _arg_3:Bool)
        {
            var _local_4= ("popup_arrow_" + (_arg_2 ? "left" : "right"));
            var _local_5= cast(k.findChildByName(_local_4), IBitmapWrapperWindow);
            if (!_arg_3)
            {
                if (_local_5 != null)
                {
                    _local_5.visible = false;
                }
            }
            else
            {
                if (_local_5 == null)
                {
                    _local_5 = this._navigator.getButton(_local_4, _local_4, null);
                    _local_5.setParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, false);
                    k.addChild(_local_5);
                }
                _local_5.visible = true;
                _local_5.y = Std.int((k.height * 0.5) - (_local_5.height * 0.5));
                _local_5.x = (_arg_2 ? (1 - _local_5.width) : (k.width - 1));
            }
        }

        function _Str_10545(k:TimerEvent)
        {
            this._popup.visible = true;
            this._popup.activate();
        }

        function _Str_6823(k:TimerEvent)
        {
            if (this._popup != null)
            {
                this._popup.visible = false;
            }
        }

        public function _Str_14696()
        {
            if (this._popup != null)
            {
                this._popup.visible = false;
            }
            this._displayTimer.reset();
            this._hideTimer.reset();
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return (!(this._popup == null)) && this._popup.visible;
        }

        public function refreshContent(k:IWindowContainer)
        {
        }

        function _Str_22278(k:WindowEvent, _arg_2:IWindow)
        {
            if (Std.downcast(k , WindowMouseEvent) == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                this._hideTimer.reset();
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    if (!Util._Str_21690(this._popup))
                    {
                        this._Str_17240();
                    }
                }
            }
        }
    }

