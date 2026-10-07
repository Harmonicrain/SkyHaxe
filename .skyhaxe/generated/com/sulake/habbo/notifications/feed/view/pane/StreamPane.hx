package com.sulake.habbo.notifications.feed.view.pane
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.notifications.feed.NotificationView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.notifications.feed.view.content.IFeedEntity;

     class StreamPane extends AbstractPane 
    {
        var _list:IItemListWindow;

        public function new(k:String, _arg_2:NotificationView, _arg_3:IWindowContainer)
        {
            super(k, _arg_2, _arg_3, AbstractPane.PANE_VIEW_LEVEL_FEED);
            this._list = Std.downcast(window.findChildByName("list") , IItemListWindow);
        }

        override public function dispose()
        {
            this._list = null;
            super.dispose();
        }

        public function addItem(k:IFeedEntity)
        {
            this._list.addListItem(k.window);
        }
    }

