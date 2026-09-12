package com.sulake.habbo.notifications.feed
;
    import com.sulake.habbo.notifications.HabboNotifications;
    import com.sulake.habbo.notifications.feed.view.content.EntityFactory;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.notifications.feed.data.GenericNotificationItemData;
    import com.sulake.habbo.utils.HabboWebTools;

     class NotificationController 
    {
        var _component:HabboNotifications;
        var _baseView:NotificationView;
        var _settings:FeedSettings;
        var _entityFactory:EntityFactory;

        public function new(k:HabboNotifications)
        {
            this._component = k;
            this._settings = new FeedSettings(this);
            this._baseView = new NotificationView(this, k);
            this._entityFactory = new EntityFactory();
            this._component.roomSessionManager.events.addEventListener(RoomSessionEvent.CREATED, this.onRoomSessionEventHandler);
            this._component.roomSessionManager.events.addEventListener(RoomSessionEvent.STARTED, this.onRoomSessionEventHandler);
            this._component.roomSessionManager.events.addEventListener(RoomSessionEvent.ENDED, this.onRoomSessionEventHandler);
        }

        public function dispose()
        {
            if (this._baseView != null)
            {
                this._baseView.dispose();
                this._baseView = null;
            }
            this._component.roomSessionManager.events.removeEventListener(RoomSessionEvent.CREATED, this.onRoomSessionEventHandler);
            this._component.roomSessionManager.events.removeEventListener(RoomSessionEvent.STARTED, this.onRoomSessionEventHandler);
            this._component.roomSessionManager.events.removeEventListener(RoomSessionEvent.ENDED, this.onRoomSessionEventHandler);
            this._component = null;
            if (this._settings != null)
            {
                this._settings.dispose();
                this._settings = null;
            }
            if (this._entityFactory != null)
            {
                this._entityFactory.dispose();
                this._entityFactory = null;
            }
        }

        function onRoomSessionEventHandler(k:RoomSessionEvent)
        {
            switch (k.type)
            {
                case RoomSessionEvent.CREATED
                   | RoomSessionEvent.STARTED
                   | RoomSessionEvent.ENDED:
                    if (this._baseView != null)
                    {
                        this._baseView.setGameMode(k.session.isGameSession);
                    }
                    return;
            }
        }

        public function setFeedEnabled(k:Bool)
        {
            if (this._baseView != null)
            {
                this._baseView.setViewEnabled(k);
            }
        }

        public function getSettings():FeedSettings
        {
            return this._settings;
        }

        public function updateFeedCategoryFiltering()
        {
        }

        public function addFeedItem(k:Int, _arg_2:GenericNotificationItemData)
        {
            var _local_3= this._entityFactory._Str_23084(_arg_2);
            this._baseView.addNotificationFeedItem(k, _local_3);
        }

        public function executeAction(k:String)
        {
            if (k.indexOf("http") == 0)
            {
                HabboWebTools.openWebPage(k);
            }
        }
    }

