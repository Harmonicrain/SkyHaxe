package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.ui.widget.memenu.MeMenuWidget;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.inventory.events.HabboInventoryEffectsEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.help._enum.HabboHelpTutorialEvent;
    import com.sulake.habbo.catalog.purse.PurseEvent;
    import com.sulake.habbo.messenger.events.MiniMailMessageEvent;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetAvatarExpressionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDanceMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChangePostureMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetGetEffectsMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetSelectEffectMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenInventoryMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenCatalogMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetStopEffectMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetNavigateToRoomMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetAvatarEditorMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetSelectOutfitMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetShowOwnRoomsMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMeMenuMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetGetSettingsMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetStoreSettingsMessage;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.ui.widget.events._Str_5638;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.ui.widget.events._Str_5907;
    import com.sulake.habbo.ui.widget.events._Str_4656;
    import com.sulake.habbo.ui.widget.events._Str_3963;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;
    import com.sulake.habbo.ui.widget.events._Str_3950;
    import com.sulake.habbo.ui.widget.events._Str_4677;

     class MeMenuWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _inventory:IHabboInventory;
        var _toolbar:IHabboToolbar;
        var _catalog:IHabboCatalog;
        var _widget:MeMenuWidget;

        public function new()
        {
            Logger.log(["[MeMenuWidgetHandler]"]);
        }

        public var widget(never,set):MeMenuWidget;
public function  set_widget(k:MeMenuWidget):MeMenuWidget        {
            return this._widget = k;
        }

        public function dispose()
        {
            if (((this._container != null) && (this._container.avatarEditor != null)))
            {
                this._container.avatarEditor.close(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            }
            this._isDisposed = true;
            this.container = null;
            this._inventory = null;
            this._toolbar = null;
            this._catalog = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ME_MENU;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            if (this._container != null)
            {
                if ((((this._inventory != null) && (!this._inventory.disposed)) && (this._inventory.events != null)))
                {
                    this._inventory.events.removeEventListener(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED, this.onAvatarEffectsChanged);
                    this._inventory.events.removeEventListener(HabboInventoryHabboClubEvent.HIHCE_HABBO_CLUB_CHANGED, this.onHabboClubSubscriptionChanged);
                }
                if ((((this._toolbar != null) && (!this._toolbar.disposed)) && (this._toolbar.events != null)))
                {
                    this._toolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onHabboToolbarEvent);
                }
                if ((((this._container.habboHelp != null) && (!this._container.habboHelp.disposed)) && (this._container.habboHelp.events != null)))
                {
                    this._container.habboHelp.events.removeEventListener(HabboHelpTutorialEvent.HHTPNUFWE_LIGHT_CLOTHES_ICON, this.onHelpTutorialEvent);
                    this._container.habboHelp.events.removeEventListener(HabboHelpTutorialEvent.HHTPNUFWE_AVATAR_TUTORIAL_START, this.onHelpTutorialEvent);
                }
                if ((((this._container.catalog != null) && (!this._container.catalog.disposed)) && (this._container.catalog.events != null)))
                {
                    this._container.catalog.events.removeEventListener(PurseEvent.CATALOG_PURSE_CREDIT_BALANCE, this.onCreditBalance);
                }
                if ((((this._container.messenger != null) && (!this._container.messenger.disposed)) && (this._container.messenger.events != null)))
                {
                    this._container.messenger.events.removeEventListener(MiniMailMessageEvent.MMME_NEW, this.onMiniMailNewMessage);
                    this._container.messenger.events.removeEventListener(MiniMailMessageEvent.MMME_UNREAD, this.onMiniMailUnreadCount);
                }
            }
            this._container = k;
            if (this._container == null)
            {
                return k;
            }
            this._inventory = this._container.inventory;
            if (this._inventory != null)
            {
                this._inventory.events.addEventListener(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED, this.onAvatarEffectsChanged);
                this._inventory.events.addEventListener(HabboInventoryHabboClubEvent.HIHCE_HABBO_CLUB_CHANGED, this.onHabboClubSubscriptionChanged);
            }
            this._toolbar = this._container.toolbar;
            if (((this._toolbar != null) && (this._toolbar.events != null)))
            {
                this._toolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onHabboToolbarEvent);
            }
            if (this._container.habboHelp != null)
            {
                this._container.habboHelp.events.addEventListener(HabboHelpTutorialEvent.HHTPNUFWE_LIGHT_CLOTHES_ICON, this.onHelpTutorialEvent);
                this._container.habboHelp.events.addEventListener(HabboHelpTutorialEvent.HHTPNUFWE_AVATAR_TUTORIAL_START, this.onHelpTutorialEvent);
            }
            this._catalog = this._container.catalog;
            if (this._container.catalog != null)
            {
                this._container.catalog.events.addEventListener(PurseEvent.CATALOG_PURSE_CREDIT_BALANCE, this.onCreditBalance);
            }
            if ((((this._container.messenger != null) && (!this._container.messenger.disposed)) && (this._container.messenger.events != null)))
            {
                this._container.messenger.events.addEventListener(MiniMailMessageEvent.MMME_NEW, this.onMiniMailNewMessage);
                this._container.messenger.events.addEventListener(MiniMailMessageEvent.MMME_UNREAD, this.onMiniMailUnreadCount);
            }
return k;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (((this.disposed || (!(this._container != null))) || (!(this._container.events != null))))
            {
                return;
            }
            if (k.type == HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                switch (k.iconId)
                {
                    case HabboToolbarIconEnum.MEMENU:
                        return;
                }
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetAvatarExpressionMessage.RWCM_MESSAGE_AVATAR_EXPRESSION);
            k.push(RoomWidgetDanceMessage.RWCM_MESSAGE_DANCE);
            k.push(RoomWidgetChangePostureMessage.RWCPM_MESSAGE_CHANGE_POSTURE);
            k.push(RoomWidgetGetEffectsMessage.RWCM_MESSAGE_GET_EFFECTS);
            k.push(RoomWidgetSelectEffectMessage.RWCM_MESSAGE_SELECT_EFFECT);
            k.push(RoomWidgetSelectEffectMessage.RWCM_MESSAGE_UNSELECT_EFFECT);
            k.push(RoomWidgetSelectEffectMessage.RWCM_MESSAGE_UNSELECT_ALL_EFFECTS);
            k.push(RoomWidgetOpenInventoryMessage.RWGOI_MESSAGE_OPEN_INVENTORY);
            k.push(RoomWidgetOpenCatalogMessage.RWGOI_MESSAGE_OPEN_CATALOG);
            k.push(RoomWidgetStopEffectMessage.RWGOI_MESSAGE_STOP_EFFECT);
            k.push(RoomWidgetNavigateToRoomMessage.RWGOI_MESSAGE_NAVIGATE_TO_ROOM);
            k.push(RoomWidgetNavigateToRoomMessage.RWGOI_MESSAGE_NAVIGATE_HOME);
            k.push(RoomWidgetAvatarEditorMessage.RWCM_OPEN_AVATAR_EDITOR);
            k.push(RoomWidgetAvatarEditorMessage.RWCM_GET_WARDROBE);
            k.push(RoomWidgetSelectOutfitMessage.SELECT_OUTFIT);
            k.push(RoomWidgetShowOwnRoomsMessage.RWSORM_SHOW_OWN_ROOMS);
            k.push(RoomWidgetRequestWidgetMessage.RWRWM_ME_MENU);
            k.push(RoomWidgetMeMenuMessage.RWMMM_MESSAGE_ME_MENU_OPENED);
            k.push(RoomWidgetGetSettingsMessage.RWGSM_GET_SETTINGS);
            k.push(RoomWidgetStoreSettingsMessage.RWSSM_STORE_SETTINGS);
            k.push(RoomWidgetStoreSettingsMessage.RWSSM_STORE_SOUND);
            k.push(RoomWidgetStoreSettingsMessage.RWSSM_PREVIEW_SOUND);
            k.push(RoomWidgetStoreSettingsMessage.RWSSM_STORE_CHAT);
            k.push(RoomWidgetAvatarEditorMessage.RWAEM_AVATAR_EDITOR_VIEW_DISPOSED);
            k.push(RoomWidgetRequestWidgetMessage.RWRWM_EFFECTS);
            return k;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetOpenCatalogMessage = null;
            var _local_3:RoomWidgetOpenInventoryMessage = null;
            var _local_4:RoomWidgetMeMenuMessage = null;
            var _local_5:RoomWidgetStoreSettingsMessage = null;
            var _local_6:HabboToolbarEvent = null;
            var _local_7:RoomWidgetDanceMessage = null;
            var _local_8:RoomWidgetChangePostureMessage = null;
            var _local_9:Array<ASAny> = null;
            var _local_10:RoomWidgetSelectEffectMessage = null;
            var _local_11:RoomWidgetSelectEffectMessage = null;
            var _local_12 = false;
            var _local_13 = 0;
            var _local_14:RoomUserData = null;
            var _local_15 = 0;
            if (k == null)
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetRequestWidgetMessage.RWRWM_ME_MENU:
                    if ((((!(this._container == null)) && (!(this._container.toolbar == null))) && (!(this._container.toolbar.events == null))))
                    {
                        _local_6 = new HabboToolbarEvent(HabboToolbarEvent.HTE_TOOLBAR_CLICK);
                        _local_6.iconId = HabboToolbarIconEnum.MEMENU;
                        if (((((!this.disposed) && (this._container != null)) && (this._container.toolbar != null)) && (this._container.toolbar.events != null)))
                        {
                            this._container.toolbar.events.dispatchEvent(_local_6);
                        }
                    }
                    
                case RoomWidgetAvatarExpressionMessage.RWCM_MESSAGE_AVATAR_EXPRESSION:
                    if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                    {
                        this._container.roomSession.sendAvatarExpressionMessage(cast(k, RoomWidgetAvatarExpressionMessage).animation.ordinal);
                    }
                    
                case RoomWidgetDanceMessage.RWCM_MESSAGE_DANCE:
                    if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                    {
                        _local_7 = Std.downcast(k , RoomWidgetDanceMessage);
                        if (_local_7 != null)
                        {
                            this._container.roomSession.sendDanceMessage(_local_7.style);
                        }
                    }
                    
                case RoomWidgetChangePostureMessage.RWCPM_MESSAGE_CHANGE_POSTURE:
                    if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                    {
                        _local_8 = Std.downcast(k , RoomWidgetChangePostureMessage);
                        if (_local_8 != null)
                        {
                            this._container.roomSession.sendChangePostureMessage(_local_8.posture);
                        }
                    }
                    
                case RoomWidgetGetEffectsMessage.RWCM_MESSAGE_GET_EFFECTS:
                    if (this._inventory != null)
                    {
                        _local_9 = this._inventory.getAvatarEffects();
                        this._container.events.dispatchEvent(new _Str_5638(_local_9));
                    }
                    
                case RoomWidgetSelectEffectMessage.RWCM_MESSAGE_SELECT_EFFECT:
                    if (this._inventory != null)
                    {
                        _local_10 = Std.downcast(k , RoomWidgetSelectEffectMessage);
                        this._inventory.setEffectSelected(_local_10.effectType);
                    }
                    
                case RoomWidgetSelectEffectMessage.RWCM_MESSAGE_UNSELECT_EFFECT:
                    if (this._inventory != null)
                    {
                        _local_11 = Std.downcast(k , RoomWidgetSelectEffectMessage);
                        this._inventory.setEffectDeselected(_local_11.effectType);
                    }
                    
                case RoomWidgetOpenCatalogMessage.RWGOI_MESSAGE_OPEN_CATALOG:
                    _local_2 = Std.downcast(k , RoomWidgetOpenCatalogMessage);
                    if (((!(this._catalog == null)) && (_local_2._Str_23670 == RoomWidgetOpenCatalogMessage.RWOCM_CLUB_MAIN)))
                    {
                        this._catalog.openClubCenter();
                    }
                    
                case RoomWidgetOpenInventoryMessage.RWGOI_MESSAGE_OPEN_INVENTORY:
                    _local_3 = Std.downcast(k , RoomWidgetOpenInventoryMessage);
                    if (this._inventory != null)
                    {
                        Logger.log([("MeMenuWidgetHandler open inventory: " + _local_3._Str_16732)]);
                        switch (_local_3._Str_16732)
                        {
                            case RoomWidgetOpenInventoryMessage.INVENTORY_EFFECTS:
                                this._catalog.openCatalogPage(CatalogPageName.AVATAR_EFFECTS);
                                
                            case RoomWidgetOpenInventoryMessage.INVENTORY_BADGES:
                                this._inventory.toggleInventoryPage(InventoryCategory.BADGES);
                                
                            case RoomWidgetOpenInventoryMessage.INVENTORY_FURNITURE:
                                this._inventory.toggleInventoryPage(InventoryCategory.FURNI);
                                
                            case RoomWidgetOpenInventoryMessage.INVENTORY_CLOTHES:
                                
                            default:
                                Logger.log([("MeMenuWidgetHandler: unknown inventory type: " + _local_3._Str_16732)]);
                        }
                    }
                    
                case RoomWidgetSelectEffectMessage.RWCM_MESSAGE_UNSELECT_ALL_EFFECTS
                   | RoomWidgetStopEffectMessage.RWGOI_MESSAGE_STOP_EFFECT:
                    Logger.log(["STOP ALL EFFECTS"]);
                    if (this._inventory != null)
                    {
                        this._inventory.deselectAllEffects(true);
                    }
                    
                case RoomWidgetNavigateToRoomMessage.RWGOI_MESSAGE_NAVIGATE_HOME:
                    Logger.log(["MeMenuWidgetHandler: GO HOME"]);
                    if (this._container != null)
                    {
                        this._container.navigator.goToHomeRoom();
                    }
                    
                case RoomWidgetShowOwnRoomsMessage.RWSORM_SHOW_OWN_ROOMS:
                    if (this._container != null)
                    {
                        this._container.navigator.showOwnRooms();
                    }
                    
                case RoomWidgetMeMenuMessage.RWMMM_MESSAGE_ME_MENU_OPENED:
                    _local_4 = Std.downcast(k , RoomWidgetMeMenuMessage);
                    if ((((!(_local_4 != null)) || (!(this._container != null))) || (!(this._container.events != null))))
                    {
                        return null;
                    }
                    if (this._inventory != null)
                    {
                        _local_12 = false;
                        if (((!(this._container == null)) && (!(this._container.sessionDataManager == null))))
                        {
                            _local_12 = (this._container.sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB);
                        }
                        this._container.events.dispatchEvent(new _Str_5907(this._inventory.clubDays, this._inventory.clubPeriods, this._inventory.clubPastPeriods, _local_12, this._inventory.clubLevel));
                    }
                    if (((!(this._catalog == null)) && (!(this._catalog.getPurse() == null))))
                    {
                        this._container.events.dispatchEvent(new _Str_4656(_Str_4656.RWPUE_CREDIT_BALANCE, this._catalog.getPurse().credits));
                    }
                    if ((((this._container.roomSession != null) && (this._container.roomSession.userDataManager != null)) && (this._container.roomEngine != null)))
                    {
                        _local_13 = ((this._container.sessionDataManager != null) ? this._container.sessionDataManager.userId : -1);
                        _local_14 = this._container.roomSession.userDataManager.getUserData(_local_13);
                        if (_local_14 == null)
                        {
                            return null;
                        }
                        _local_15 = 0;
                        this._container.roomEngine.selectAvatar(_local_15, _local_14.roomObjectId);
                    }
                    
                case RoomWidgetAvatarEditorMessage.RWCM_OPEN_AVATAR_EDITOR:
                    Logger.log(["MeMenuWidgetHandler: Open avatar editor..."]);
                    if (this._container != null)
                    {
                        this._container.avatarEditor.openEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR, null, null, true);
                        this._container.avatarEditor.loadOwnAvatarInEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
                        if (((this._container.habboHelp != null) && (this._container.habboHelp.events != null)))
                        {
                            this._container.habboHelp.events.dispatchEvent(new HabboHelpTutorialEvent(HabboHelpTutorialEvent.HHTE_DONE_AVATAR_EDITOR_OPENING));
                        }
                    }
                    
                case RoomWidgetGetSettingsMessage.RWGSM_GET_SETTINGS:
                    this._container.events.dispatchEvent(new _Str_3963(_Str_3963.RWSUE_SETTINGS, this._container.soundManager.traxVolume, this._container.soundManager.furniVolume, this._container.soundManager.genericVolume));
                    
                case RoomWidgetStoreSettingsMessage.RWSSM_STORE_SOUND:
                    this._container.soundManager.traxVolume = Std.downcast(k , RoomWidgetStoreSettingsMessage).traxVolume;
                    this._container.soundManager.furniVolume = Std.downcast(k , RoomWidgetStoreSettingsMessage).furniVolume;
                    this._container.soundManager.genericVolume = Std.downcast(k , RoomWidgetStoreSettingsMessage).genericVolume;
                    this._container.events.dispatchEvent(new _Str_3963(_Str_3963.RWSUE_SETTINGS, this._container.soundManager.traxVolume, this._container.soundManager.furniVolume, this._container.soundManager.genericVolume));
                    
                case RoomWidgetStoreSettingsMessage.RWSSM_PREVIEW_SOUND:
                    _local_5 = Std.downcast(k , RoomWidgetStoreSettingsMessage);
                    this._container.soundManager.previewVolume(_local_5.genericVolume, _local_5.furniVolume, _local_5.traxVolume);
                    this._container.events.dispatchEvent(new _Str_3963(_Str_3963.RWSUE_SETTINGS, this._container.soundManager.traxVolume, this._container.soundManager.furniVolume, this._container.soundManager.genericVolume));
                    
                case RoomWidgetAvatarEditorMessage.RWAEM_AVATAR_EDITOR_VIEW_DISPOSED:
                    if (((this._container.habboHelp != null) && (this._container.habboHelp.events != null)))
                    {
                        this._container.habboHelp.events.dispatchEvent(new HabboHelpTutorialEvent(HabboHelpTutorialEvent.HHTE_DONE_AVATAR_EDITOR_CLOSING));
                    }
                    
                case RoomWidgetStoreSettingsMessage.RWSSM_STORE_CHAT:
                    if (this._container.freeFlowChat != null)
                    {
                        this._container.freeFlowChat.isDisabledInPreferences = cast(k, RoomWidgetStoreSettingsMessage)._Str_12967;
                        if (!cast(k, RoomWidgetStoreSettingsMessage)._Str_12967)
                        {
                            if (((this._container.layoutManager != null) && (this._container.layoutManager.getChatContainer() != null)))
                            {
                                this._container.layoutManager.getChatContainer().setDisplayObject(this._container.freeFlowChat.displayObject);
                            }
                        }
                        else
                        {
                            this._container.freeFlowChat.clear();
                        }
                    }
                    
                default:
                    Logger.log([("Unhandled message in MeMenuWidgetHandler: " + k.type)]);
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processEvent(k:Event)
        {
        }

        public function update()
        {
        }

        function onAvatarEffectsChanged(k:Event=null)
        {
            var _local_2:Array<ASAny> = null;
            if (this._container == null)
            {
                return;
            }
            Logger.log(["[MeMenuWidgetHandler] Received Avatar Effects Have Changed Event...\t"]);
            if (this._inventory != null)
            {
                _local_2 = this._inventory.getAvatarEffects();
                this._container.events.dispatchEvent(new _Str_5638(_local_2));
            }
        }

        function onHabboClubSubscriptionChanged(k:Event=null)
        {
            var _local_2 = false;
            if (this._inventory != null)
            {
                _local_2 = false;
                if (((!(this._container == null)) && (!(this._container.sessionDataManager == null))))
                {
                    _local_2 = (this._container.sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB);
                }
                this._container.events.dispatchEvent(new _Str_5907(this._inventory.clubDays, this._inventory.clubPeriods, this._inventory.clubPastPeriods, _local_2, this._inventory.clubLevel));
            }
        }

        function onCreditBalance(k:PurseEvent)
        {
            if ((((k == null) || (this._container == null)) || (this._container.events == null)))
            {
                return;
            }
            this._container.events.dispatchEvent(new _Str_4656(_Str_4656.RWPUE_CREDIT_BALANCE, k.balance));
        }

        function onHelpTutorialEvent(k:HabboHelpTutorialEvent)
        {
            if (this._container == null)
            {
                return;
            }
            switch (k.type)
            {
                case HabboHelpTutorialEvent.HHTPNUFWE_AVATAR_TUTORIAL_START:
                    this._container.events.dispatchEvent(new _Str_3950(_Str_3950.HHTPNUFWE_AE_STARTED));
                    return;
                case HabboHelpTutorialEvent.HHTPNUFWE_LIGHT_CLOTHES_ICON:
                    this._container.events.dispatchEvent(new _Str_3950(_Str_3950.HHTPNUFWE_AE_HIGHLIGHT));
                    return;
            }
        }

        function onMiniMailNewMessage(k:MiniMailMessageEvent)
        {
            this._container.events.dispatchEvent(new _Str_4677(_Str_4677.RWMMUE_NEW_MINI_MAIL));
        }

        function onMiniMailUnreadCount(k:MiniMailMessageEvent)
        {
            this._container.events.dispatchEvent(new _Str_4677(_Str_4677.RWMMUE_UNREAD_MINI_MAIL));
        }
    }

