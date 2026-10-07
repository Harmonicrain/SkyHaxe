package com.sulake.habbo.ui.widget.roomtools
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.ui.handler.RoomToolsWidgetHandler;

     class RoomToolsCtrlBase 
    {
        static inline final DISTANCE_FROM_BOTTOM= 55;
        static inline final TOOLBAR_X= -5;
        static inline final WINDOW_ANIM_SPEED= 100;

        var _window:IWindowContainer;
        var _widget:RoomToolsWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _isCollapsed:Bool = true;
        var _windowCollapseTimer:Timer;
        var _windowCollapsePending:Bool = false;
        var _windowCollapseDelay:Int = 0;

        public function new(k:RoomToolsWidget, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            this._widget = k;
            this._windowManager = _arg_2;
            this._assets = _arg_3;
            this._windowCollapseDelay = this.handler.container.config.getInteger("room.enter.info.collapse.delay", 5000);
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.procedure = null;
                this._window.dispose();
                this._window = null;
            }
            if (this._windowCollapseTimer != null)
            {
                this._windowCollapseTimer.reset();
                this._windowCollapseTimer = null;
                this._windowCollapsePending = false;
            }
            this._widget = null;
        }

        public function setElementVisible(k:String, _arg_2:Bool)
        {
            if (((!(this._window != null)) || (!(this._window.findChildByName(k) != null))))
            {
                return;
            }
            this._window.findChildByName(k).visible = _arg_2;
        }

        function collapseAfterDelay()
        {
            this.clearCollapseTimer();
            this._windowCollapseTimer = new Timer(this._windowCollapseDelay, 1);
            this._windowCollapseTimer.addEventListener(TimerEvent.TIMER, (this.collapseTimerEventHandler : ASAny));
            this._windowCollapseTimer.start();
        }

        function collapseIfPending()
        {
            if (this._windowCollapsePending)
            {
                this.collapseAfterDelay();
            }
        }

        function clearCollapseTimer()
        {
            if (this._windowCollapseTimer != null)
            {
                this._windowCollapseTimer.reset();
                this._windowCollapseTimer = null;
            }
            this._windowCollapsePending = false;
        }

        function collapseTimerEventHandler(k:TimerEvent)
        {
            this.clearCollapseTimer();
            this.setCollapsed(true);
        }

        function cancelWindowCollapse()
        {
            if (this._windowCollapseTimer != null)
            {
                this.clearCollapseTimer();
                this._windowCollapsePending = true;
            }
        }

        public function setCollapsed(k:Bool)
        {
        }

        public var isCollapsed(get,never):Bool;
public function  get_isCollapsed():Bool
        {
            return this._isCollapsed;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public var handler(get,never):RoomToolsWidgetHandler;
public function  get_handler():RoomToolsWidgetHandler
        {
            return (this._widget != null) ? this._widget.handler : null;
        }
    }

