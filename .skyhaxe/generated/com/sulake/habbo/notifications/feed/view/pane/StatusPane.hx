package com.sulake.habbo.notifications.feed.view.pane
;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.notifications.feed.NotificationView;
    import com.sulake.core.window.IWindowContainer;

     class StatusPane extends AbstractPane 
    {
        static inline final MINIMIZE_TOGGLE= "minimize_toggle";
        static inline final NOTIFICATION_FEED_BUTTON= "notification_feed_button";
        static inline final STREAM_FEED_BUTTON= "stream_feed_button";

        public function new(k:String, _arg_2:NotificationView, _arg_3:IWindowContainer)
        {
            super(k, _arg_2, _arg_3, AbstractPane.PANE_VIEW_LEVEL_BASE);
            window.findChildByName(MINIMIZE_TOGGLE).addEventListener(WindowMouseEvent.CLICK, this._Str_15286);
            window.findChildByName(NOTIFICATION_FEED_BUTTON).addEventListener(WindowMouseEvent.CLICK, this._Str_23102);
            window.findChildByName(STREAM_FEED_BUTTON).addEventListener(WindowMouseEvent.CLICK, this._Str_22735);
        }

        override public function dispose()
        {
            if (window != null)
            {
                window.findChildByName(MINIMIZE_TOGGLE).removeEventListener(WindowMouseEvent.CLICK, this._Str_15286);
                window.findChildByName(NOTIFICATION_FEED_BUTTON).removeEventListener(WindowMouseEvent.CLICK, this._Str_23102);
                window.findChildByName(STREAM_FEED_BUTTON).removeEventListener(WindowMouseEvent.CLICK, this._Str_22735);
            }
        }

        function _Str_15286(k:WindowMouseEvent)
        {
            _mainView.toggleMinimized();
        }

        function _Str_23102(k:WindowMouseEvent)
        {
            _mainView.switchToPane(NotificationView.PANE_NOTIFICATIONS);
        }

        function _Str_22735(k:WindowMouseEvent)
        {
            _mainView.switchToPane(NotificationView.PANE_STREAM);
        }
    }

