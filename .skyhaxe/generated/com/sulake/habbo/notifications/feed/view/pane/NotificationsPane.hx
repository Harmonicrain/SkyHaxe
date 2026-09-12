package com.sulake.habbo.notifications.feed.view.pane
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.notifications.feed.NotificationView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.notifications.feed.view.content.IFeedEntity;
    import com.sulake.habbo.notifications.feed.FeedSettings;

     class NotificationsPane extends AbstractPane 
    {
        static inline final LIST= "list";
        static inline final LIST_URGENT= "list_urgent";
        static inline final LIST_ACTIONS= "list_actions";
        static inline final LIST_PERSISTENT= "list_persistent";
        static inline final LIST_NOTIFICATIONS= "list_notifications";

        var _list:IItemListWindow;

        public function new(k:String, _arg_2:NotificationView, _arg_3:IWindowContainer)
        {
            super(k, _arg_2, _arg_3, AbstractPane.PANE_VIEW_LEVEL_FEED);
            this._Str_22512();
        }

        override public function dispose()
        {
            this._list = null;
            super.dispose();
        }

        function _Str_22512()
        {
            this._list = Std.downcast(window.findChildByName(LIST) , IItemListWindow);
        }

        public function addItem(k:Int, _arg_2:IFeedEntity)
        {
            var _local_3= this._Str_23056(k);
            _local_3.addListItemAt(_arg_2.window, 0);
        }

        function _Str_23056(k:Int):IItemListWindow
        {
            var _local_2:String = null;
            switch (k)
            {
                case FeedSettings.FEED_SECTION_URGENT:
                    _local_2 = LIST_URGENT;
                    
                case FeedSettings.FEED_SECTION_ACTIONS:
                    _local_2 = LIST_ACTIONS;
                    
                case FeedSettings.FEED_SECTION_PERSISTENT:
                    _local_2 = LIST_PERSISTENT;
                    
                case FeedSettings.FEED_SECTION_NOTIFICATIONS:
                    _local_2 = LIST_NOTIFICATIONS;
                    
            }
            return Std.downcast(this._list.getListItemByName(_local_2) , IItemListWindow);
        }
    }

