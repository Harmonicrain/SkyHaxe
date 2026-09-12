package com.sulake.habbo.notifications
;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
	import com.sulake.habbo.communication.messages.incoming.notifications.SimpleAlertMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.RoomUserRespect;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboBroadcastMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboAchievementNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.ClubGiftNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboActivityPointNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.UserBannedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.HotelClosesAndWillOpenAtEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.pets.PetReceivedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.OpenConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.MOTDNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.recycler.RecyclerFinishedEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.PetLevelNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RoomMessageNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.RestoreClientMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.AccountSafetyLockStatusChangeMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.InfoFeedEnableMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubGiftSelectedEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.MaintenanceStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorCautionEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.NotificationDialogMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.HotelWillCloseInMinutesEvent;
    import com.sulake.habbo.communication.messages.incoming.room.pets.PetRespectFailedEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.HotelClosedAndOpensEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTransactionSuccessMessageEvent;
    import com.sulake.habbo.notifications.feed.data.GenericNotificationItemData;
    import com.sulake.habbo.notifications.NotificationPopup;
    import com.sulake.habbo.notifications.feed.FeedSettings;
    import flash.display.BitmapData;
    import com.sulake.core.localization.ILocalization;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetFigureData;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.Pet;
    import com.sulake.habbo.window._enum.FrankIllustration;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;

     class IncomingMessages 
    {
        var _notifications:HabboNotifications;
        var _communication:IHabboCommunicationManager;
        var _messageEvents:Vector<IMessageEvent>;

        public function new(k:HabboNotifications, _arg_2:IHabboCommunicationManager)
        {
            this._notifications = k;
            this._communication = _arg_2;
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new RoomUserRespect(this.onRespectNotification));
            this.addMessageEvent(new HabboBroadcastMessageEvent(this.onBroadcastMessageEvent));
            this.addMessageEvent(new HabboAchievementNotificationMessageEvent(this.onLevelUp));
            this.addMessageEvent(new ClubGiftNotificationEvent(this.onClubGiftNotification));
            this.addMessageEvent(new ModeratorMessageEvent(this.onModMessageEvent));
            this.addMessageEvent(new HabboActivityPointNotificationMessageEvent(this.onActivityPointNotification));
            this.addMessageEvent(new UserBannedMessageEvent(this.onUserBannedMessageEvent));
            this.addMessageEvent(new HotelClosesAndWillOpenAtEvent(this.onHotelClosed));
            this.addMessageEvent(new PetReceivedMessageEvent(this.onPetReceived));
            this.addMessageEvent(new OpenConnectionMessageEvent(this.onRoomEnter));
            this.addMessageEvent(new MOTDNotificationEvent(this.onMOTD));
            this.addMessageEvent(new RecyclerFinishedEvent(this.onRecyclerFinished));
            this.addMessageEvent(new PetLevelNotificationEvent(this.onPetLevelNotification));
            this.addMessageEvent(new RoomMessageNotificationMessageEvent(this.onRoomMessagesNotification));
            this.addMessageEvent(new RestoreClientMessageEvent(this.onRestoreClientMessageEvent));
            this.addMessageEvent(new AccountSafetyLockStatusChangeMessageEvent(this.onAccountSafetyLockStatusChanged));
            this.addMessageEvent(new InfoFeedEnableMessageEvent(this.onInfoFeedEnable));
            this.addMessageEvent(new UserObjectEvent(this.onUserObject));
            this.addMessageEvent(new ClubGiftSelectedEvent(this.onClubGiftSelected));
            this.addMessageEvent(new MaintenanceStatusMessageEvent(this.onHotelMaintenance));
            this.addMessageEvent(new ModeratorCautionEvent(this.onModCautionEvent));
            this.addMessageEvent(new NotificationDialogMessageEvent(this.onNotificationDialogMessageEvent));
            this.addMessageEvent(new HotelWillCloseInMinutesEvent(this.onHotelClosing));
            this.addMessageEvent(new PetRespectFailedEvent(this.onPetRespectFailed));
            this.addMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            this.addMessageEvent(new HotelClosedAndOpensEvent(this.onLoginFailedHotelClosed));
            this.addMessageEvent(new WiredTransactionSuccessMessageEvent(this.onWiredTransactionSuccess));
			this.addMessageEvent(new SimpleAlertMessageEvent(this.alertMessageHandler));
            this._notifications.activate();
        }

        function addMessageEvent(k:IMessageEvent)
        {
            this._messageEvents.push(this._communication.addHabboConnectionMessageEvent(k));
        }

        function onWiredTransactionSuccess(
            event:WiredTransactionSuccessMessageEvent)
        {
            var contents=
                event.getParser().contents;
            var key= "wired_transactions.notification.success." +
                Std.string(contents.transactionSuccessTypeId);
            if (contents.rewardContents != null && !contents.openByDefault)
                key += ".click_to_popup";
            var link= contents.rewardContents == null ? null :
                "wiredrewards/open/" + Std.string(contents.internalId);
            var message=
                this._notifications.localization.getLocalizationWithParams(
                    key,
                    this._notifications.localization.getLocalization(
                        "wired_transactions.notification.success"));
            this._notifications.addItem(message, NotificationType.INFO,
                "chests_icon_successful", link);
        }

        public function dispose()
        {
            var k:IMessageEvent = null;
            if (((!(this._messageEvents == null)) && (!(this._communication == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communication.removeHabboConnectionMessageEvent(k);
                }
            }
            this._messageEvents = null;
            this._notifications = null;
            this._communication = null;
        }

        function useNotificationFeed():Bool
        {
            return this._notifications.getBoolean("notification.feed.enabled");
        }

        function useNotifications():Bool
        {
            return this._notifications.getBoolean("notification.items.enabled");
        }

        @:allow(com.sulake.habbo.notifications) function onMOTD(k:IMessageEvent)
        {
            var _local_4:String = null;
            var _local_5:GenericNotificationItemData = null;
            var _local_2= Std.downcast(k , MOTDNotificationEvent);
            var _local_3= _local_2.getParser() ;
            if (((_local_3.messages != null) && (_local_3.messages.length > 0)))
            {
                if (this.useNotifications())
                {
                    new NotificationPopup(_local_3.messages, this._notifications.assetLibrary, this._notifications.windowManager);
                }
                if (this.useNotificationFeed())
                {
                    final _iter_ = _local_3.messages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_4  = _tmp_;
                        _local_5 = new GenericNotificationItemData();
                        _local_5.title = _local_4;
                        _local_5.timeStamp = flash.Lib.getTimer();
                        this._notifications.feedController.addFeedItem(FeedSettings.FEED_SECTION_NOTIFICATIONS, _local_5);
                    }
                }
            }
        }

        function onLevelUp(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HabboAchievementNotificationMessageEvent);
            var _local_3= _local_2.getParser();
            var _local_4= this._notifications.localization.getLocalization("achievements.levelup.desc", "");
            var _local_5= this._notifications.localization.getBadgeName(_local_3.data.badgeCode);
            var _local_6= this._notifications.sessionDataManager.requestBadgeImage(_local_3.data.badgeCode);
            this._notifications.singularController.addItem(((_local_4 + " ") + _local_5), NotificationType.ACHIEVEMENT, _local_6, null, _local_3.data.badgeCode, ("questengine/achievements/" + _local_3.data.category));
        }

        @:allow(com.sulake.habbo.notifications) function onRespectNotification(k:IMessageEvent)
        {
            var _local_3:ILocalization = null;
            var _local_4:ILocalization = null;
            var _local_2= Std.downcast(k , RoomUserRespect);
            if (this._notifications.sessionDataManager.userId == _local_2.userId)
            {
                this._notifications.localization.registerParameter("notifications.text.respect.2", "count", Std.string(_local_2.respectTotal));
                _local_3 = this._notifications.localization.getLocalizationRaw("notifications.text.respect.1");
                _local_4 = this._notifications.localization.getLocalizationRaw("notifications.text.respect.2");
                if (_local_3 != null)
                {
                    this._notifications.singularController.addItem(_local_3.value, NotificationType.RESPECT, null);
                }
                if (_local_4 != null)
                {
                    this._notifications.singularController.addItem(_local_4.value, NotificationType.RESPECT, null);
                }
            }
        }

        function onRoomMessagesNotification(k:RoomMessageNotificationMessageEvent)
        {
            var _local_3:ILocalization = null;
            var _local_2= k.getParser();
            var _local_4= NotificationType.ROOMMESSAGESPOSTED;
            this._notifications.localization.registerParameter("notifications.text.room.messages.posted", "room_name", _local_2.roomName);
            this._notifications.localization.registerParameter("notifications.text.room.messages.posted", "messages_count", Std.string(_local_2._Str_25507));
            _local_3 = this._notifications.localization.getLocalizationRaw("notifications.text.room.messages.posted");
            var _local_5= Std.downcast(this._notifications.assets.getAssetByName("if_icon_temp_png") , BitmapDataAsset);
            var _local_6= ASCompat.dynamicAs(_local_5.content , BitmapData);
            if (_local_3 != null)
            {
                this._notifications.singularController.addItem(_local_3.value, _local_4, _local_6.clone());
            }
        }

        function onRecyclerFinished(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RecyclerFinishedEvent).getParser();
            if (((_local_2 == null) || (!(_local_2.recyclerFinishedStatus == RecyclerFinishedEvent._Str_15052))))
            {
                return;
            }
            var _local_3= this._notifications.localization.getLocalizationRaw("notifications.text.recycle.ok");
            if (_local_3 != null)
            {
                this._notifications.singularController.addItem(_local_3.value, NotificationType.RECYCLEROK, null);
            }
            Logger.log(["[HabboNotifications] recycle ok"]);
        }

        function onInfoFeedEnable(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , InfoFeedEnableMessageEvent);
            if (_local_2 != null)
            {
                this._notifications.disabled = (!_local_2.enabled);
            }
        }

        function onModCautionEvent(k:IMessageEvent)
        {
            var _local_3:GenericNotificationItemData = null;
            var _local_2= Std.downcast(k , ModeratorCautionEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            if (this.useNotifications())
            {
                this._notifications.singularController.alertDialogManager.handleModeratorCaution(_local_2.message, _local_2.url);
            }
            if (this.useNotificationFeed())
            {
                _local_3 = new GenericNotificationItemData();
                _local_3.title = _local_2.message;
                _local_3._Str_15192 = _local_2.url;
                _local_3.buttonCaption = _local_2.url;
                _local_3.timeStamp = flash.Lib.getTimer();
                this._notifications.feedController.addFeedItem(FeedSettings.FEED_SECTION_NOTIFICATIONS, _local_3);
            }
        }

        function onModMessageEvent(k:IMessageEvent)
        {
            var _local_3:GenericNotificationItemData = null;
            var _local_2= Std.downcast(k , ModeratorMessageEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            if (this.useNotifications())
            {
                this._notifications.singularController.alertDialogManager.handleModeratorMessage(_local_2.message, _local_2.url);
            }
            if (this.useNotificationFeed())
            {
                _local_3 = new GenericNotificationItemData();
                _local_3.title = _local_2.message;
                _local_3._Str_15192 = _local_2.url;
                _local_3.buttonCaption = _local_2.url;
                _local_3.timeStamp = flash.Lib.getTimer();
                this._notifications.feedController.addFeedItem(FeedSettings.FEED_SECTION_NOTIFICATIONS, _local_3);
            }
        }

        function onUserBannedMessageEvent(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserBannedMessageEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            this._notifications.singularController.alertDialogManager.handleUserBannedMessage(_local_2.message);
        }

        function onHotelClosing(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HotelWillCloseInMinutesEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            this._notifications.singularController.alertDialogManager.handleHotelClosingMessage(_local_2.minutes);
        }

        function onHotelMaintenance(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , MaintenanceStatusMessageEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            this._notifications.singularController.alertDialogManager.handleHotelMaintenanceMessage(_local_2.minutesUntilMaintenance, _local_2.duration);
        }

        function onHotelClosed(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HotelClosesAndWillOpenAtEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            this._notifications.singularController.alertDialogManager.handleHotelClosedMessage(_local_2.openHour, _local_2.openMinute, _local_2.userThrownOutAtClose);
        }

        function onLoginFailedHotelClosed(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HotelClosedAndOpensEvent).getParser();
            if (((_local_2 == null) || (this._notifications.singularController.alertDialogManager == null)))
            {
                return;
            }
            this._notifications.singularController.alertDialogManager.handleLoginFailedHotelClosedMessage(_local_2.openHour, _local_2.openMinute);
        }

        function onRestoreClientMessageEvent(k:IMessageEvent)
        {
            HabboWebTools.closeWebPageAndRestoreClient();
        }

        function onPetLevelNotification(k:PetLevelNotificationEvent)
        {
            var _local_4:PetFigureData = null;
            var _local_5:BitmapData = null;
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            this._notifications.localization.registerParameter("notifications.text.petlevel", "pet_name", _local_2.petName);
            this._notifications.localization.registerParameter("notifications.text.petlevel", "level", Std.string(_local_2.level));
            var _local_3= this._notifications.localization.getLocalizationRaw("notifications.text.petlevel");
            if (_local_3 != null)
            {
                _local_4 = _local_2.figureData;
                _local_5 = this._notifications.petImageUtility.getPetImage(_local_4.typeId, _local_4.paletteId, _local_4.color);
                this._notifications.singularController.addItem(_local_3.value, NotificationType.PETLEVEL, _local_5);
            }
        }

        function onPetReceived(k:PetReceivedMessageEvent)
        {
            var _local_3:ILocalization = null;
            var _local_4:Pet = null;
            var _local_5:BitmapData = null;
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2.boughtAsGift)
            {
                _local_3 = this._notifications.localization.getLocalizationRaw("notifications.text.petbought");
            }
            else
            {
                _local_3 = this._notifications.localization.getLocalizationRaw("notifications.text.petreceived");
            }
            if (_local_3 != null)
            {
                _local_4 = _local_2.pet;
                _local_5 = this._notifications.petImageUtility.getPetImage(_local_4.typeId, _local_4.paletteId, _local_4.color);
                this._notifications.singularController.addItem(_local_3.value, NotificationType.PETLEVEL, _local_5);
            }
        }

        function onRoomEnter(k:IMessageEvent)
        {
            this._notifications.singularController.showModerationDisclaimer();
        }

        function onBroadcastMessageEvent(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HabboBroadcastMessageEvent).getParser();
            var _local_3= _local_2.messageText;
            var _local_4= new compat.RegExp("\\\\r", "g");
            _local_3 = _local_4.replace(_local_3, "\r");
            this._notifications.windowManager.simpleAlert("${notifications.broadcast.title}", "", _local_3, "", "", null, FrankIllustration.NEUTRAL);
        }

        function onNotificationDialogMessageEvent(k:NotificationDialogMessageEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.type == "discord_activity")
            {
                this._notifications.showDiscordActivityDialog();
                return;
            }
            this._notifications.showNotification(_local_2.type, _local_2.parameters);
        }

        function onPetRespectFailed(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PetRespectFailedEvent).getParser();
            this._notifications.localization.registerParameter("room.error.pets.respectfailed", "required_age", ("" + Std.string(_local_2.currentAge)));
            this._notifications.localization.registerParameter("room.error.pets.respectfailed", "avatar_age", ("" + Std.string(_local_2.requiredAge)));
            this._notifications.windowManager.alert("${error.title}", "${room.error.pets.respectfailed}", 0, this.onAlert);
        }
		
		function alertMessageHandler(k:IMessageEvent)
		{
			var packet= Std.downcast(k , SimpleAlertMessageEvent).getParser();
			var titleMessage= "${notifications.broadcast.title}";
			
			if (ASCompat.stringAsBool(packet.titleMessage))
			{
				titleMessage = packet.titleMessage;
			}
			this._notifications.windowManager.alert(titleMessage, packet.alertMessage, 0, this.onAlert);
		}

        public function onAlert(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (((_arg_2.type == WindowEvent.WINDOW_EVENT_OK) || (_arg_2.type == WindowEvent.WINDOW_EVENT_CANCEL)))
            {
                k.dispose();
            }
        }

        function onClubGiftNotification(k:ClubGiftNotificationEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.numGifts < 1)
            {
                return;
            }
            this._notifications.singularController.showClubGiftNotification(_local_2.numGifts);
        }

        function onUserObject(k:UserObjectEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.accountSafetyLocked)
            {
                this._notifications.singularController.showSafetyLockedNotification(_local_2.id);
            }
        }

        function onAccountSafetyLockStatusChanged(k:AccountSafetyLockStatusChangeMessageEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.status == 1)
            {
                this._notifications.singularController.hideSafetyLockedNotification();
            }
        }

        function onClubGiftSelected(k:ClubGiftSelectedEvent)
        {
            if (((!(k != null)) || (!(this._notifications.localization != null))))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.products;
            if (((!(_local_3 != null)) || (_local_3.length == 0)))
            {
                return;
            }
            var _local_4= ASCompat.dynamicAs(_local_3[0] , CatalogPageMessageProductData);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= this._notifications.localization.getLocalization("notifications.text.club_gift.received");
            var _local_6= this._notifications.productImageUtility._Str_23662(_local_4.productType, _local_4.furniClassId, _local_4.extraParam);
            this._notifications.singularController.addItem(_local_5, NotificationType.INFO, _local_6);
        }

        function onActivityPointNotification(k:HabboActivityPointNotificationMessageEvent)
        {
            var _local_2:String = null;
            var _local_3:BitmapData = null;
            if (k.change <= 0)
            {
                return;
            }
            switch (k.type)
            {
                case ActivityPointTypeEnum.LOYALTY:
                    _local_2 = this._notifications.localization.getLocalizationWithParams("notifications.text.loyalty.received", "", ["amount", k.change]);
                    _local_3 = ASCompat.dynamicAs(this._notifications.assets.getAssetByName("if_icon_diamond_png").content , BitmapData);
                    
                default:
                    return;
            }
            this._notifications.singularController.addItem(_local_2, NotificationType.INFO, _local_3.clone());
        }
    }

