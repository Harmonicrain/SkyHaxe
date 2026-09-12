package com.sulake.habbo.notifications.singular
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.notifications.HabboNotifications;
    import com.sulake.core.utils.Map;
	import com.sulake.habbo.notifications.singular.HabboNotificationItemStyle;
	import com.sulake.habbo.notifications.singular.HabboNotificationItem;
	import com.sulake.habbo.notifications.singular.HabboAlertDialogManager;
	import com.sulake.habbo.notifications.singular.SafetyLockedNotification;
	import com.sulake.habbo.notifications.singular.ClubGiftNotification;
    import flash.utils.Timer;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.utils.XMLVariableParser;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.notifications.NotificationType;
    import com.sulake.room.utils.RoomEnterEffect;

     class SingularNotificationController implements IUpdateReceiver 
    {
        static inline final MODERATION_DISCLAIMER_DELAY_MS= 5000;

        var _notifications:HabboNotifications;
        var _notificationQueue:Array<ASAny>;
        var _styleConfiguration:Map;
        var _notificationViewManager:HabboNotificationViewManager;
        var _alertDialogManager:HabboAlertDialogManager;
        var _moderationDisclaimerShown:Bool = false;
        var _clubGiftNotification:ClubGiftNotification;
        var _safetyLockedNotification:SafetyLockedNotification;
        var _achievementNotifications:ASDictionary<ASAny,ASAny>;
        var _moderationDelayTimer:Timer;
        var _isDisposed:Bool = false;

        public function new(k:HabboNotifications)
        {
            var _local_5 = 0;
            var _local_6:Map = null;
            var _local_7:BitmapDataAsset = null;
            var _local_8:BitmapData = null;
            this._notifications = k;
            this._notificationQueue = new Array<ASAny>();
            this._styleConfiguration = new Map();
            this._achievementNotifications = new ASDictionary<ASAny,ASAny>();
            this._alertDialogManager = new HabboAlertDialogManager(this._notifications.windowManager, this._notifications.localization, this._notifications.habboHelp);
            var _local_2= this._notifications.assetLibrary.getAssetByName("habbo_notifications_config_xml");
            var _local_3= cast(_local_2, XmlAsset);
            if (_local_3 != null)
            {
                XMLVariableParser.parseVariableList(new com.sulake.core.utils.xml.XML(_local_3.content).children(), this._styleConfiguration);
            }
            var _local_4:Map = this._styleConfiguration.getValue("styles");
            if (_local_4 != null)
            {
                _local_5 = 0;
                while ((_local_5 : UInt) < _local_4.length)
                {
                    _local_6 = _local_4.getWithIndex(_local_5);
                    if (_local_6.getValue("icon")!= null)
                    {
                        _local_7 = Std.downcast(this._notifications.assetLibrary.getAssetByName(_local_6.getValue("icon")) , BitmapDataAsset);
                        _local_8 = ASCompat.dynamicAs(_local_7.content , BitmapData);
                        _local_6.setProperty("icon", _local_8);
                    }
                    _local_5++;
                }
            }
            this._notificationViewManager = new HabboNotificationViewManager(this._notifications, this._notifications.assetLibrary, this._notifications.windowManager, this._notifications.toolBar, this._styleConfiguration.getValue("styles"), this._styleConfiguration);
            this._notifications.sessionDataManager.events.addEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this.onBadgeImage);
            this._notifications.registerUpdateReceiver(this, 2);
        }

        public var alertDialogManager(get,never):HabboAlertDialogManager;
public function  get_alertDialogManager():HabboAlertDialogManager
        {
            return this._alertDialogManager;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            if (this._moderationDelayTimer != null)
            {
                this._moderationDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowModerationDisclaimer : ASAny));
                this._moderationDelayTimer = null;
            }
            if (this._notificationViewManager != null)
            {
                this._notificationViewManager.dispose();
                this._notificationViewManager = null;
            }
            if (this._alertDialogManager != null)
            {
                this._alertDialogManager.dispose();
                this._alertDialogManager = null;
            }
            if (this._clubGiftNotification != null)
            {
                this._clubGiftNotification.dispose();
                this._clubGiftNotification = null;
            }
            if (this._safetyLockedNotification != null)
            {
                this._safetyLockedNotification.dispose();
                this._safetyLockedNotification = null;
            }
            if (this._notifications != null)
            {
                this._notifications.removeUpdateReceiver(this);
                this._notifications = null;
            }
            this._isDisposed = true;
        }

        public function update(k:UInt)
        {
            var _local_2:HabboNotificationItem = null;
            if ((this._notificationViewManager._Str_19647() && (this._notificationQueue.length > 0)))
            {
                _local_2 = this.getNextItemFromQueue();
                if (!this._notificationViewManager.showItem(_local_2))
                {
                    _local_2.dispose();
                }
            }
        }

        public function addItem(k:String, _arg_2:String, _arg_3:BitmapData, _arg_4:String=null, _arg_5:String=null, _arg_6:String=null, _arg_7:ASObject=null):Int
        {
            if (this._notifications.disabled)
            {
                return 0;
            }
            var _local_7:Map = this._styleConfiguration.getValue("styles");
            if (_local_7 == null)
            {
                return 0;
            }
            var _local_8:Map = _local_7.getValue(_arg_2);
            if (_local_8 == null)
            {
                return 0;
            }
            var notificationId= _arg_7 != null ? ASCompat.getDynamicProperty(_arg_7, "id"): null;
            if (notificationId != null && this.hasNotificationById(notificationId))
            {
                return this._notificationQueue.length;
            }
            var _local_9= new HabboNotificationItemStyle(_local_8, _arg_3, _arg_4, true, _arg_5, _arg_7, _arg_2);
            if (ASCompat.stringAsBool(_arg_6))
            {
                _local_9.internalLink = _arg_6;
            }
            var _local_10= new HabboNotificationItem(k, _local_9, this);
            this._notificationQueue.push(_local_10);
            return this._notificationQueue.length;
        }

        public function removeNotificationById(id:String)
        {
var item:HabboNotificationItem  = null;            if (id == null)
            {
                return;
            }
            var i= 0;
            while (i < this._notificationQueue.length)
            {
item=
                    ASCompat.dynamicAs(this._notificationQueue[i] , HabboNotificationItem);
                if (item != null && item.notificationId == id)
                {
                    item.dispose();
                    this._notificationQueue.splice(i, 1);
                    continue;
                }
                i++;
            }
            if (this._notificationViewManager != null)
            {
                this._notificationViewManager.removeNotificationById(id);
            }
        }

        function hasNotificationById(id:String):Bool
        {
var item:HabboNotificationItem  = null;            if (id == null)
            {
                return false;
            }
            final _iter_ = this._notificationQueue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item = _tmp_;
                if (item != null && item.notificationId == id)
                {
                    return true;
                }
            }
            return this._notificationViewManager != null
                && this._notificationViewManager.hasNotificationById(id);
        }

        function getNextItemFromQueue():HabboNotificationItem
        {
            var k= this._notificationQueue.splice(0, 1);
            return ASCompat.dynamicAs(k[0] , HabboNotificationItem);
        }

        public function addSongPlayingNotification(k:String, _arg_2:String)
        {
            this._notifications.localization.registerParameter("soundmachine.notification.playing", "songname", k);
            this._notifications.localization.registerParameter("soundmachine.notification.playing", "songauthor", _arg_2);
            var _local_3= this._notifications.localization.getLocalizationRaw("soundmachine.notification.playing");
            if (_local_3 != null)
            {
                this.addItem(_local_3.value, NotificationType.SOUNDMACHINE, null);
            }
        }

        public function onInternalLink(k:String)
        {
            this._notifications.createLinkEvent(k);
        }

        function onShowModerationDisclaimer(k:TimerEvent)
        {
            this._moderationDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowModerationDisclaimer : ASAny));
            this._moderationDelayTimer = null;
            this.showModerationDisclaimer();
        }

        public function showModerationDisclaimer()
        {
            var k:String = null;
            if (RoomEnterEffect.isRunning())
            {
                if (this._moderationDelayTimer == null)
                {
                    this._moderationDelayTimer = new Timer((RoomEnterEffect.totalRunningTime + MODERATION_DISCLAIMER_DELAY_MS), 1);
                    this._moderationDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowModerationDisclaimer : ASAny));
                    this._moderationDelayTimer.start();
                }
            }
            else
            {
                if (!this._moderationDisclaimerShown)
                {
                    k = this._notifications.localization.getLocalization("mod.chatdisclaimer", "NA");
                    this.addItem(k, NotificationType.INFO, null);
                    this._moderationDisclaimerShown = true;
                    Logger.log([("DISPLAYED MOD INFO: " + k)]);
                }
            }
        }

        public function showClubGiftNotification(k:Int)
        {
            if (((this._clubGiftNotification != null) && this._clubGiftNotification.visible))
            {
                return;
            }
            this._clubGiftNotification = new ClubGiftNotification(k, this._notifications.assets, this._notifications.windowManager, this._notifications.catalog, this._notifications.toolBar);
        }

        public function showSafetyLockedNotification(k:Int)
        {
            if (((this._safetyLockedNotification != null) && this._safetyLockedNotification.visible))
            {
                return;
            }
            this._safetyLockedNotification = new SafetyLockedNotification(k, this._notifications.assets, this._notifications.windowManager, this._notifications.catalog, this._notifications.toolBar);
        }

        public function hideSafetyLockedNotification()
        {
            if (this._safetyLockedNotification == null)
            {
                return;
            }
            this._safetyLockedNotification.dispose();
        }

        function onBadgeImage(k:BadgeImageReadyEvent)
        {
            if (((!(k == null)) && (!(this._notificationViewManager == null))))
            {
                this._notificationViewManager.replaceIcon(k);
            }
        }
    }

