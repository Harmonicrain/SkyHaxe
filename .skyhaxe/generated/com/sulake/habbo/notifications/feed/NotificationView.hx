package com.sulake.habbo.notifications.feed
;
    import com.sulake.habbo.notifications.HabboNotifications;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.notifications.feed.view.content.FeedEntity;
    import com.sulake.habbo.notifications.feed.view.pane.AbstractPane;
    import com.sulake.habbo.notifications.FeedVisibilityEnum;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.notifications.feed.view.pane.NotificationsPane;
    import com.sulake.habbo.notifications.feed.view.pane.StreamPane;
    import com.sulake.habbo.notifications.feed.view.pane.InfoPane;
    import com.sulake.habbo.notifications.feed.view.pane.SettingsPane;
    import com.sulake.habbo.notifications.feed.view.pane.StatusPane;
    import com.sulake.habbo.notifications.feed.view.pane.IPane;
    import com.sulake.habbo.notifications.feed.view.content.IFeedEntity;

     class NotificationView 
    {
        public static inline final PANE_FEEDS= "pane_feeds";
        public static inline final PANE_NOTIFICATIONS= "pane_notifications";
        public static inline final PANE_STREAM= "pane_stream";
        public static inline final PANE_SETTINGS= "pane_settings";
        public static inline final PANE_INFO= "pane_info";
        public static inline final PANE_STATUS= "pane_status";
        static inline final SETTINGS_TOGGLE= "settings_toggle";
        static inline final INFO_TOGGLE= "info_toggle";

        var _stateController:StateController;
        var _component:HabboNotifications;
        var _controller:NotificationController;
        var _window:IWindowContainer;
        var _views:Map;

        public function new(k:NotificationController, _arg_2:HabboNotifications)
        {
            this._controller = k;
            this._component = _arg_2;
            this._stateController = new StateController();
            FeedEntity._Str_23222(this.windowManager, this.assets, this.localization, k);
            this.setupUserInterface();
            this.closePaneLevel(AbstractPane.PANE_VIEW_LEVEL_MODAL);
            this.switchToPane(PANE_NOTIFICATIONS);
            this.setVisibilityState(FeedVisibilityEnum.VIEW_STATE_MINIMIZED);
        }

        public function dispose()
        {
            var k:IDisposable = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._views != null)
            {
                final _iter_ = this._views; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._views.dispose();
                this._views = null;
            }
            FeedEntity._Str_23840();
            this._controller = null;
            this._stateController = null;
            this._component = null;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._component.windowManager;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._component.assets;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._component.localization;
        }

        public var controller(get,never):NotificationController;
public function  get_controller():NotificationController
        {
            return this._controller;
        }

        function setupUserInterface()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = Std.downcast(this._component.windowManager.buildFromXML(((this._component.assets.getAssetByName("feed_display_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.height = this._window.desktop.height;
            this._window.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_MOVE);
            this._window.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH);
            this._window.findChildByName(SETTINGS_TOGGLE).addEventListener(WindowMouseEvent.CLICK, this.onSettingsToggle);
            this._window.findChildByName(INFO_TOGGLE).addEventListener(WindowMouseEvent.CLICK, this.onInfoToggle);
            this._views = new Map();
            this._views.add(PANE_NOTIFICATIONS, new NotificationsPane(PANE_NOTIFICATIONS, this, Std.downcast(this._window.findChildByName(PANE_NOTIFICATIONS) , IWindowContainer)));
            this._views.add(PANE_STREAM, new StreamPane(PANE_STREAM, this, Std.downcast(this._window.findChildByName(PANE_STREAM) , IWindowContainer)));
            this._views.add(PANE_INFO, new InfoPane(PANE_INFO, this, Std.downcast(this._window.findChildByName(PANE_INFO) , IWindowContainer)));
            this._views.add(PANE_SETTINGS, new SettingsPane(PANE_SETTINGS, this, Std.downcast(this._window.findChildByName(PANE_SETTINGS) , IWindowContainer)));
            this._views.add(PANE_STATUS, new StatusPane(PANE_STATUS, this, Std.downcast(this._window.findChildByName(PANE_STATUS) , IWindowContainer)));
        }

        public function toggleMinimized()
        {
            switch (this._stateController.currentState())
            {
                case FeedVisibilityEnum.VIEW_STATE_MAXIMIZED:
                    this.setVisibilityState(FeedVisibilityEnum.VIEW_STATE_MINIMIZED);
                    return;
                case FeedVisibilityEnum.VIEW_STATE_MINIMIZED:
                    this.setVisibilityState(FeedVisibilityEnum.VIEW_STATE_MAXIMIZED);
                    return;
            }
        }

        public function setVisibilityState(k:Int)
        {
            var _local_3:IWindowContainer = null;
            var _local_2= this._stateController.requestState(k);
            switch (_local_2)
            {
                case FeedVisibilityEnum.VIEW_STATE_HIDDEN:
                    this._window.x = this._window.desktop.width;
                    this._window.visible = false;
                    return;
                case FeedVisibilityEnum.VIEW_STATE_MINIMIZED:
                    this._window.visible = true;
                    _local_3 = Std.downcast(this._window.findChildByName("main_view") , IWindowContainer);
                    this._window.x = (this._window.desktop.width - (this._window.width - _local_3.width));
                    return;
                case FeedVisibilityEnum.VIEW_STATE_MAXIMIZED:
                    this._window.visible = true;
                    this._window.x = (this._window.desktop.width - this._window.width);
                    return;
            }
        }

        public function setViewEnabled(k:Bool)
        {
            this._stateController.setEnabled(k);
            this.setVisibilityState(this._stateController.currentState());
        }

        public function setGameMode(k:Bool)
        {
            this._stateController.setGameMode(k);
            this.setVisibilityState(this._stateController.currentState());
        }

        public function switchToPane(k:String)
        {
            var _local_2:IPane = this._views.getValue(k);
            if (_local_2 == null)
            {
                return;
            }
            this.closePaneLevel(_local_2._Str_16687);
            _local_2.isVisible = true;
        }

        public function closePaneLevel(k:Int)
        {
            var _local_2:AbstractPane = null;
            final _iter_ = this._views; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (_local_2._Str_16687 == k)
                {
                    _local_2.isVisible = false;
                }
            }
        }

        public function addNotificationFeedItem(k:Int, _arg_2:IFeedEntity)
        {
            ASCompat.dynamicAs(this._views.getValue(PANE_NOTIFICATIONS) , NotificationsPane).addItem(k, _arg_2);
        }

        public function addStreamFeedItem(k:IFeedEntity)
        {
            ASCompat.dynamicAs(this._views.getValue(PANE_STREAM) , StreamPane).addItem(k);
        }

        public function removeStreamItems()
        {
        }

        function onSettingsToggle(k:WindowMouseEvent)
        {
            var _local_2= ASCompat.dynamicAs(this._views.getValue(PANE_SETTINGS) , IPane);
            if (_local_2 != null)
            {
                if (_local_2.isVisible)
                {
                    this.closePaneLevel(AbstractPane.PANE_VIEW_LEVEL_MODAL);
                }
                else
                {
                    this.switchToPane(PANE_SETTINGS);
                }
            }
        }

        function onInfoToggle(k:WindowMouseEvent)
        {
            var _local_2= ASCompat.dynamicAs(this._views.getValue(PANE_INFO) , IPane);
            if (_local_2 != null)
            {
                if (_local_2.isVisible)
                {
                    this.closePaneLevel(AbstractPane.PANE_VIEW_LEVEL_MODAL);
                }
                else
                {
                    this.switchToPane(PANE_INFO);
                }
            }
        }
    }

