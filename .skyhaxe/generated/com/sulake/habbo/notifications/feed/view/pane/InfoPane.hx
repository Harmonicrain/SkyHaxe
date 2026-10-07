package com.sulake.habbo.notifications.feed.view.pane
;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.notifications.feed.NotificationView;
    import com.sulake.core.window.IWindowContainer;

     class InfoPane extends AbstractPane 
    {
        public function new(k:String, _arg_2:NotificationView, _arg_3:IWindowContainer)
        {
            super(k, _arg_2, _arg_3, AbstractPane.PANE_VIEW_LEVEL_MODAL);
            Std.downcast(window.findChildByName("info_ok") , IContainerButtonWindow).addEventListener(WindowMouseEvent.CLICK, this._Str_19389);
        }

        override public function dispose()
        {
            var k:IContainerButtonWindow = null;
            super.dispose();
            if (window != null)
            {
                k = Std.downcast(window.findChildByName("info_ok") , IContainerButtonWindow);
                if (k != null)
                {
                    k.removeEventListener(WindowMouseEvent.CLICK, this._Str_19389);
                    k = null;
                }
            }
        }

        function _Str_19389(k:WindowMouseEvent)
        {
            _mainView.closePaneLevel(AbstractPane.PANE_VIEW_LEVEL_MODAL);
        }
    }

